<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal">
    <span @click="onClose" class="absolute top-0 bottom-0 right-0 px-4 py-3">
      <svg class="ill-current h-6 w-6 text-black-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
    </span>
    <Input label="Title" placeholder="Title" extraInputClasses="w-full" v-model="state.form.title" />
    <button 
      @click="searchForMoviesAndTv"
      :disabled="titleEmpty || state.searching"
      class="btn-white btn mb-3">
      {{ buttonText }}
    </button>

    <div v-show="!state.fetchingDetails">
      <h3 v-show="hasMovieOptions && !state.movieSelected" class="font-bold">Movies</h3>
      <div 
        v-show="hasMovieOptions && !state.movieSelected"
        @click="movieSelected(i)"
        :key="i + 100" v-for="(movie, i) in movieOptions" 
        class="flex-grow flex px-4 py-2 items-center border-b">
        <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
          <img :src="movie.thumbnail" width="50" height="50">
        </div>
        <div class="flex w-3/5 md:w3/4 text-gray-600">
          <span>
            {{ movie.title }}
          </span>
        </div>
      </div>

      <h3 v-show="hasMovieOptions && !state.movieSelected" class="font-bold">TV shows</h3>
      <div 
        v-show="hasTvOptions && !state.movieSelected"
        @click="tvSelected(i)"
        :key="i + 1" v-for="(movie, i) in tvOptions" 
        class="flex-grow flex px-4 py-2 items-center border-b">
        <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
          <img :src="movie.thumbnail" width="50" height="50">
        </div>
        <div class="flex w-3/5 md:w3/4 text-gray-600">
          <span>
            {{ movie.title }}
          </span>
        </div>
      </div>

      <p v-show="!hasOptions && !state.searching">No movies or tv shows found</p>
    </div>
    <h4 v-show="state.fetchingDetails" class="italic">Fetching details...</h4>

    <div v-show="state.movieSelected" class="flex flex-col">
      <img class="mb-2 mt-2" v-show="hasThumbnail" :src="state.form.thumbnail" width="150" height="150">
      <VueTagsInput v-model="state.tag" :tags="state.tags" @tags-changed="updateTags" />
      <button @click="saveMovie" class="btn btn-blue mt-3">Save</button>
    </div>
  </div>
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import VueTagsInput from '@johmun/vue-tags-input';
import axios from 'axios';
import Input from '@/components/Input';

const inDevelopment = process.env.NODE_ENV === 'development';

export default {
  name: 'AddMovie',
  components: {
    Input,
    VueTagsInput
  },
  props: {
    tmdbToken: {
      type: String,
      required: true
    }
  },
  setup(props, { emit }) {
    const currentYear = new Date().getFullYear();
    const tmdbBaseUrl = 'https://api.themoviedb.org/3/';
    const imgPrefix = 'https://image.tmdb.org/t/p/w200';
    let timeout;
    const state = reactive({
      options: [],
      searching: false,
      movieSelected: false,
      fetchingDetails: false,
      tag: '',
      form: {
        title: '',
        imdb_id: '',
        notes: '',
        tags: [],
        thumbnail: null
      }
    });

    const buttonText = computed(() => state.searching ? 'Searching...' : 'Search');
    const titleEmpty = computed(() => state.form.title.length === 0);
    const hasThumbnail = computed(() => state.form.thumbnail && state.form.thumbnail.length > 0);
    const movieOptions = computed(() => state.options.filter(({ tv }) => !tv));
    const tvOptions = computed(() => state.options.filter(({ tv }) => tv));
    const hasMovieOptions = computed(() => movieOptions.value.length > 0);
    const hasTvOptions = computed(() => tvOptions.value.length > 0);
    const hasOptions = computed(() => hasTvOptions.value || hasMovieOptions.value);

    const prefixProxy = (url) => inDevelopment ? `https://cors-anywhere.herokuapp.com/${url}` : url;
    const searchUrl = (query, resource) =>
      prefixProxy(`${tmdbBaseUrl}search/${resource}?api_key=${props.tmdbToken}&query=${encodeURI(query)}`);
    const movieDetailsUrl = (id) => prefixProxy(`${tmdbBaseUrl}movie/${id}?api_key=${props.tmdbToken}`);
    const tvDetailsUrl = (id) =>
      prefixProxy(`${tmdbBaseUrl}tv/${id}?api_key=${props.tmdbToken}&append_to_response=external_ids`);

    const getMovieOptions = (str) => axios
      .get(searchUrl(str, 'movie'))
      .then(({ data: { results } }) => results
        .map(({ poster_path, id, title }) => {
          const thumbnail = poster_path ? `${imgPrefix}${poster_path}` : 'https://via.placeholder.com/200';

          return { thumbnail, id, title, tv: false };
        }))
      .catch((response) => ([]));
    
    const getTvOptions = (str) => axios
      .get(searchUrl(str, 'tv'))
      .then(({ data: { results } }) => results
        .map(({ poster_path, id, name }) => ({ thumbnail: `${imgPrefix}${poster_path}`, id, title: name, tv: true })))
      .catch((response) => ([]));

    const searchForMoviesAndTv = () => {
      if (timeout) clearTimeout(timeout);
      const title = state.form.title.trim();
      
      timeout = setTimeout(() => {
        state.options = [];
        state.searching = true;
        Promise.all([getMovieOptions(title), getTvOptions(title)])
          .then(([movies, shows]) => {
            state.options = movies.concat(shows);
          })
          .finally(() => {
            state.searching = false;
          });
      }, 500);
    };

    const onClose = () => emit('closed');

    const updateTags = (tags) => {
      state.form.tags = tags;
    };

    const movieSelected = (index) => {
      const movie = movieOptions.value[index];
      state.fetchingDetails = true;
      axios
        .get(movieDetailsUrl(movie.id))
        .then(({ data: { imdb_id } }) => {
          state.form.title = movie.title;
          state.form.thumbnail = movie.thumbnail;
          state.form.imdb_id = imdb_id;
          state.movieSelected = true;
        })
        .catch(() => {
          alert('Could not fetch movie details');
        })
        .finally(() => {
          state.fetchingDetails = false;
        });
    };

    const tvSelected = (index) => {
      const show = tvOptions.value[index];
      state.fetchingDetails = true;
      axios
        .get(tvDetailsUrl(show.id))
        .then(({ data: { external_ids: { imdb_id } } }) => {
          state.form.title = show.title;
          state.form.thumbnail = show.thumbnail;
          state.form.imdb_id = imdb_id;
          state.movieSelected = true;
        })
        .catch(() => {
          alert('Could not fetch show details');
        })
        .finally(() => {
          state.fetchingDetails = false;
        });
    };

    const saveMovie = () => {
      const body = { ...state.form };
      body.tags.push(`${currentYear}`);
      
      axios.post('/movies', body)
        .then(({ data: { data } }) => {
          emit('movie-added', data);
          onClose();
        });
    };

    return {
      state,
      buttonText,
      onClose,
      updateTags,
      movieSelected,
      tvSelected,
      searchForMoviesAndTv,
      titleEmpty,
      hasThumbnail,
      saveMovie,
      movieOptions,
      tvOptions,
      hasMovieOptions,
      hasTvOptions,
      hasOptions
    };
  }
};
</script>
