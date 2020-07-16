<template>
  <!-- eslint-disable -->
  <div> 
    <div v-show="showList">
      <button v-show="hasMovies" class="btn btn-white ml-4 my-3 w-20" @click="showAddMovieView">Add</button>
      <MovieList v-show="hasMovies" :movies="state.movies" />
      <EmptyList v-show="!hasMovies" resource="movies" @add-movie="showAddMovieView" />
    </div>
    <div v-show="showNew">
      <AddMovie @movie-added="movieAdded" @closed="closeAddMovieView" :tmdb-token="tmdbToken" />
    </div>
  </div>
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import EmptyList from '@/components/EmptyList';
import MovieList from '@/components/MovieList';
import AddMovie from '@/components/AddMovie';
import eventBus from '@/eventBus';

export default {
  name: 'Movies',
  components: {
    AddMovie,
    EmptyList,
    MovieList
  },
  props: {
    initialMovies: {
      type: Array,
      default: () => []
    },
    tmdbToken: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const state = reactive({
      movies: props.initialMovies,
      view: 'list'
    });
    const hasMovies = computed(() => !!state.movies.length);
    const showList = computed(() => state.view === 'list');
    const showNew = computed(() => state.view === 'new');

    const showAddMovieView = () => {
      state.view = 'new';
    };
    const closeAddMovieView = () => {
      state.view = 'list';
    };
    const movieAdded = (movie) => {
      state.movies.push(movie);
    };

    eventBus.$on('movie-deleted', (movieId) => {
      state.movies = state.movies.filter(({ id }) => id !== movieId);
    });
    
    return {
      state,
      hasMovies,
      showAddMovieView,
      closeAddMovieView,
      showList,
      showNew,
      movieAdded
    };
  }
};
</script>
