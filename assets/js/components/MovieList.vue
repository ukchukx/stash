<template>
  <!-- eslint-disable -->
  <div>
    <div class="flex justify-between px-6">
      <div class="md:w-2/3 sm:w-0"></div>
      <div class="w-full md:w-1/3 flex items-center py-2">
        <input v-model="state.searchText" class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" placeholder="Search">
      </div>
    </div>
    <div class="grid grid-flow-row grid-cols-2 md:grid-cols-5 ml-8 sm:ml-0">
      <MovieItem v-for="(movie, i) in state.filteredMovies" :key="movie.id" :movie="movie" />
    </div>
    <EmptyList v-if="state.isEmpty" message="No movies" :show-button="false" />
  </div>
</template>
<script>
import { computed, reactive } from 'vue';
import MovieItem from './MovieItem.vue';
import EmptyList from './EmptyList.vue';

export default {
  name: 'MovieList',
  components: {
    EmptyList,
    MovieItem
  },
  props: {
    movies: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const showMovie = ({ title, tags }, text) => {
      if (!text) return true;
      return title.toLowerCase().includes(text) || tags.some((t) => t.includes(text));
    };
    const state = reactive({
      searchText: ''
    });
    state.filteredMovies = computed(() => {
      const text = state.searchText.trim().toLowerCase();
      return props.movies.filter((movie) => showMovie(movie, text));
    });
    state.isEmpty = computed(() => !state.filteredMovies.length);

    return {
      state
    };
  }
};
</script>
