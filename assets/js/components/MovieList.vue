<template>
  <!-- eslint-disable -->
  <div>
    <div class="flex justify-between px-6">
      <div class="md:w-2/3 sm:w-0"></div>
      <div class="w-full md:w-1/3 flex items-center py-2">
        <input v-model="searchText" class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" placeholder="Search">
      </div>
    </div>
    <MovieItem v-for="(movieItem, i) in movies" :key="i" v-show="showMovie(movieItem)" :movie="movieItem" />
  </div>
</template>
<script>
import { ref } from '@vue/composition-api';
import MovieItem from '@/components/MovieItem';

export default {
  name: 'MovieList',
  components: {
    MovieItem
  },
  props: {
    movies: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const searchText = ref('');

    const showMovie = ({ title, tags }) => {
      const search = searchText.value.trim().toLowerCase();
      const tagSearchFn = (t) => t.includes(search);
      return title.toLowerCase().includes(search) || tags.some(tagSearchFn);
    };

    return {
      searchText,
      showMovie
    };
  }
};
</script>
