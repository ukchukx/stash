<template>
  <!-- eslint-disable -->
  <Page>
    <div v-show="state.showList">
      <h2 class="text-2xl text-gray-600 font-medium my-4 text-center">{{ state.list.name }}</h2>
      <button v-if="state.hasMovies" class="btn btn-white ml-4 my-3 w-20" @click="showAddMovieView">Add</button>
      <MovieList v-if="state.hasMovies" :movies="state.movies" />
      <EmptyList v-else message="List is empty" @add-item-clicked="showAddMovieView" />
    </div>

    <div v-show="state.showNew">
      <AddMovie @closed="closeAddMovieView" :list-id="state.listId" />
    </div>
  </Page>
</template>
<script>
import { computed, reactive, onBeforeMount } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'vuex';
import EmptyList from './EmptyList.vue';
import MovieList from './MovieList.vue';
import AddMovie from './AddMovie.vue';
import Page from './Page.vue';

export default {
  name: 'Movies',
  components: {
    AddMovie,
    EmptyList,
    MovieList,
    Page
  },
  setup() {
    const store = useStore();
    const listId = useRoute().query.id;

    const state = reactive({
      view: 'list',
      listId,
      list: computed(() => store.getters.list(listId)),
      movies: computed(() => store.getters.moviesForList(listId))
    });
    state.hasMovies = computed(() => !!state.movies);
    state.showNew = computed(() => state.view === 'new');
    state.showList = computed(() => state.view === 'list');

    const showAddMovieView = () => {
      state.view = 'new';
    };
    const closeAddMovieView = () => {
      state.view = 'list';
    };
    const movieAdded = (movie) => {
      state.movies.push(movie);
    };

    onBeforeMount(() => store.dispatch('fetchMovies', state.listId));
    
    return {
      state,
      showAddMovieView,
      closeAddMovieView,
      movieAdded
    };
  }
};
</script>
