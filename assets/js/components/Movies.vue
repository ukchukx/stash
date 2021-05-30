<template>
  <!-- eslint-disable -->
  <Page>
    <div v-show="state.showList">
      <h2 
        @click="toggleTitleForm()" 
        v-show="!state.showForm" 
        class="text-2xl text-gray-600 font-medium my-4 text-center cursor-pointer">
        {{ state.list.name }}
      </h2>
      <div v-show="state.showForm" class="relative">
        <CloseButton @click="onClose" />
      </div>
      <div v-show="state.showForm" class="flex justify-between px-6 mr-4">
        <ListForm :list-type="state.list.type" :list="state.list" />
      </div>

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
import ListForm from './ListForm.vue';
import EmptyList from './EmptyList.vue';
import MovieList from './MovieList.vue';
import AddMovie from './AddMovie.vue';
import Page from './Page.vue';
import CloseButton from './CloseButton.vue';

export default {
  name: 'Movies',
  components: {
    AddMovie,
    EmptyList,
    MovieList,
    ListForm,
    CloseButton,
    Page
  },
  setup() {
    const store = useStore();
    const listId = useRoute().query.id;

    const state = reactive({
      view: 'list',
      listId,
      showForm: false
    });
    state.hasMovies = computed(() => !!state.movies);
    state.showNew = computed(() => state.view === 'new');
    state.showList = computed(() => state.view === 'list');
    state.list = computed(() => store.getters.list(listId));
    state.movies = computed(() => store.getters.moviesForList(listId));

    const showAddMovieView = () => {
      state.view = 'new';
    };
    const closeAddMovieView = () => {
      state.view = 'list';
    };
    const toggleTitleForm = () => {
      state.showForm = !state.showForm;
    };
    const onClose = () => {
      state.showForm = false;
    };

    onBeforeMount(() => store.dispatch('fetchMovies', listId));
    
    return {
      state,
      showAddMovieView,
      closeAddMovieView,
      toggleTitleForm,
      onClose
    };
  }
};
</script>
