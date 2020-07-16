<template>
  <!-- eslint-disable -->
  <Page :username="user.email">
    <Movies v-show="showMovies" :initial-movies="movies" :tmdb-token="tmdbToken" />
    <Books v-show="showBooks" :initial-books="books" />
    <Account v-show="showAccount" />
  </Page>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';
import Page from '@/components/Page';
import Movies from '@/components/Movies';
import Books from '@/components/Books';
import Account from '@/components/Account';
import eventBus from '@/eventBus';

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
