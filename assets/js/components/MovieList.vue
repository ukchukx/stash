<template>
  <!-- eslint-disable -->
  <div>
    <div class="flex justify-between px-6">
      <div class="md:w-2/3 sm:w-0"></div>
      <div class="w-full md:w-1/3 flex items-center py-2">
        <input v-model="state.searchText" class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" placeholder="Search">
      </div>
    </div>
    <MovieItem v-for="(movie, i) in state.filteredMovies" :key="i" :movie="movie" />
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
    const state = reactive({
      searchText: ''
    });
    const showMovie = ({ title, tags }, searchText) => {
      if (!searchText) return true;
      return title.toLowerCase().includes(searchText) || tags.some((t) => t.includes(searchText));
    };
    state.filteredMovies = computed(() => {
      const search = state.searchText.trim().toLowerCase();
      return props.movies.filter((movie) => showMovie(movie, search));
    });
    state.isEmpty = computed(() => !state.filteredMovies.length);

    return {
      state
    };
  }
};
</script>
