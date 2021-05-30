<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal">
    <CloseButton @click="onClose" />
    <Input 
      label="Title" 
      placeholder="Title" 
      extraInputClasses="w-full"
      @enter-pressed="searchForMoviesAndTv" 
      v-model="state.form.title" />
    <button 
      @click="searchForMoviesAndTv"
      :disabled="state.disableSearchButton"
      class="btn-white btn mb-3">
      {{ state.buttonText }}
    </button>

    <div v-show="!state.fetchingDetails">
      <h3 v-show="state.showMovieOptions" class="font-bold">Movies</h3>
      <div 
        v-show="state.showMovieOptions"
        @click="movieSelected(i)"
        :key="i" v-for="(movie, i) in state.movieOptions" 
        class="flex-grow flex px-4 py-2 items-center border-b cursor-pointer">
        <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
          <img :src="movie.thumbnail" width="50" height="50">
        </div>
        <div class="flex w-3/5 md:w3/4 text-gray-600">
          <span>
            {{ movie.title }}
          </span>
        </div>
      </div>

      <h3 v-show="state.showMovieOptions" class="font-bold">TV shows</h3>
      <div 
        v-show="state.showTvOptions"
        @click="tvSelected(i)"
        :key="i" v-for="(movie, i) in state.tvOptions" 
        class="flex-grow flex px-4 py-2 items-center border-b cursor-pointer">
        <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
          <img :src="movie.thumbnail" width="50" height="50">
        </div>
        <div class="flex w-3/5 md:w3/4 text-gray-600">
          <span>
            {{ movie.title }}
          </span>
        </div>
      </div>

      <p v-show="state.showUnsuccessfulSearchMessage">No movies or tv shows found</p>
    </div>
    <h4 v-show="state.fetchingDetails" class="italic">Fetching details...</h4>

    <div v-show="state.movieSelected" class="flex flex-col">
      <img class="mb-2 mt-2" v-show="state.hasThumbnail" :src="state.form.thumbnail" width="150" height="150">
      <button @click="saveMovie" class="btn btn-blue mt-3">Save</button>
    </div>
  </div>
</template>
<script>
import { computed, reactive } from 'vue';
import { useStore } from 'vuex';
import axios from 'axios';
import Input from './Input.vue';
import CloseButton from './CloseButton.vue';

export default {
  name: 'AddMovie',
  components: {
    Input,
    CloseButton
  },
  props: {
    listId: {
      type: String,
      required: true
    }
  },
  emits: ['closed'],
  setup(props, { emit }) {
    const store = useStore();
    const currentYear = new Date().getFullYear();
    const tmdbBaseUrl = 'https://api.themoviedb.org/3/';
    const imgPrefix = 'https://image.tmdb.org/t/p/w200';
    let timeout;
    const state = reactive({
      options: [],
      searching: false,
      searched: false,
      movieSelected: false,
      fetchingDetails: false,
      tag: '',
      form: {
        title: '',
        imdb_id: '',
        list_id: props.listId,
        thumbnail: null
      },
      tmdbToken: computed(() => store.getters.tmdbToken)
    });

    state.buttonText = computed(() => state.searching ? 'Searching...' : 'Search');
    state.disableSearchButton = computed(() => !state.form.title.length || state.searching);
    state.hasThumbnail = computed(() => state.form.thumbnail && state.form.thumbnail.length > 0);
    state.movieOptions = computed(() => state.options.filter(({ tv }) => !tv));
    state.tvOptions = computed(() => state.options.filter(({ tv }) => tv));
    state.showMovieOptions = computed(() => state.movieOptions.length > 0 && !state.movieSelected);
    state.showTvOptions = computed(() => state.tvOptions.length > 0 && !state.movieSelected);
    state.hasOptions = computed(() => !!state.tvOptions.concat(state.movieOptions).length);
    state.showUnsuccessfulSearchMessage = computed(
      () => !state.hasOptions && !state.searching && state.searched
    );

    const searchUrl = (query, resource) =>
      `${tmdbBaseUrl}search/${resource}?api_key=${state.tmdbToken}&query=${encodeURI(query)}`;
    const movieDetailsUrl = (id) => `${tmdbBaseUrl}movie/${id}?api_key=${state.tmdbToken}`;
    const tvDetailsUrl = (id) =>
      `${tmdbBaseUrl}tv/${id}?api_key=${state.tmdbToken}&append_to_response=external_ids`;

    const getMovieOptions = (str) => axios
      .get(searchUrl(str, 'movie'))
      .then(({ data: { results } }) => results
        .map(({ poster_path, id, title }) => ({ thumbnail: `${imgPrefix}${poster_path}`, id, title, tv: false })))
      .catch(() => ([]));
    
    const getTvOptions = (str) => axios
      .get(searchUrl(str, 'tv'))
      .then(({ data: { results } }) => results
        .map(({ poster_path, id, name }) => ({ thumbnail: `${imgPrefix}${poster_path}`, id, title: name, tv: true })))
      .catch(() => ([]));

    const searchForMoviesAndTv = () => {
      if (state.disableSearchButton) return;
      if (timeout) clearTimeout(timeout);
      const title = state.form.title.trim();
      
      timeout = setTimeout(() => {
        state.options = [];
        state.searching = true;
        state.searched = false;
        state.movieSelected = false;
        state.options = [];
        Promise.all([getMovieOptions(title), getTvOptions(title)])
          .then(([movies, shows]) => {
            state.options = movies.concat(shows);
          })
          .finally(() => {
            state.searching = false;
            state.searched = true;
          });
      }, 500);
    };

    const onClose = () => emit('closed');

    const updateTags = (tags) => {
      state.form.tags = tags;
    };

    const movieSelected = (index) => {
      const movie = state.movieOptions[index];
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
      const show = state.tvOptions[index];
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
      store.dispatch('createMovie', state.form)
        .then(() => {
          onClose();
        });
    };

    return {
      state,
      onClose,
      updateTags,
      movieSelected,
      tvSelected,
      searchForMoviesAndTv,
      saveMovie
    };
  }
};
</script>
