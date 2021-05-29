<template>
  <!-- eslint-disable -->
  <Page :username="user.email">
    <Movies v-show="showMovies" :initial-movies="movies" :tmdb-token="tmdbToken" />
    <Books v-show="showBooks" :initial-books="books" />
    <Account v-show="showAccount" :user="user" />
  </Page>
</template>
<script>
import { reactive, computed } from 'vue';
import Page from './Page.vue';
import Movies from './Movies.vue';
import Books from './Books.vue';
import Account from './Account.vue';
import eventBus from '../eventBus';

export default {
  name: 'Stash',
  components: {
    Account,
    Books,
    Movies,
    Page
  },
  props: {
    user: {
      type: Object,
      required: true
    },
    movies: {
      type: Array,
      required: true
    },
    books: {
      type: Array,
      required: true
    },
    tmdbToken: {
      type: String,
      required: true
    }
  },
  setup() {
    const state = reactive({
      selectedTab: 'movies'
    });

    eventBus.$on('movies-selected', () => {
      state.selectedTab = 'movies';
    });
    eventBus.$on('books-selected', () => {
      state.selectedTab = 'books';
    });
    eventBus.$on('account-selected', () => {
      state.selectedTab = 'account';
    });

    const showMovies = computed(() => state.selectedTab === 'movies');
    const showBooks = computed(() => state.selectedTab === 'books');
    const showAccount = computed(() => state.selectedTab === 'account');

    return {
      state,
      showMovies,
      showBooks,
      showAccount
    };
  }
};
</script>
