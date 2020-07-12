<template>
  <!-- eslint-disable -->
  <MovieList v-if="hasMovies" :movies="movies" />
  <EmptyList v-else resource="movies" @add-movie="addMovie" />
</template>
<script>
import { computed, ref } from '@vue/composition-api';
import EmptyList from '@/components/EmptyList';
import MovieList from '@/components/MovieList';
import eventBus from '@/eventBus';

export default {
  name: 'Movies',
  components: {
    EmptyList,
    MovieList
  },
  props: {
    initialMovies: {
      type: Array,
      default: () => []
    }
  },
  setup(props) {
    const movies = ref(props.initialMovies);
    const hasMovies = computed(() => !!movies.value.length);
    const addMovie = () => true;

    eventBus.$on('movie-deleted', (bookId) => {
      movies.value = movies.value.filter(({ id }) => id !== bookId);
    });
    
    return {
      movies,
      hasMovies,
      addMovie
    };
  }
};
</script>
