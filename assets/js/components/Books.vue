<template>
  <!-- eslint-disable -->
  <Page>
    <div v-show="state.showList">
      <h2 class="text-2xl text-gray-600 font-medium my-4 text-center">{{ state.list.name }}</h2>
      <button v-if="state.hasBooks" class="btn btn-white ml-4 my-3 w-20" @click="showAddBookView">Add</button>
      <BookList v-if="state.hasBooks" :books="state.books" />
      <EmptyList v-else rmessage="List is empty" @add-item-clicked="showAddBookView" />
    </div>
    
    <div v-show="state.showNew">
      <AddBook :list-id="state.listId" @closed="closeAddBookView" />
    </div>
  </Page>
</template>
<script>
import { computed, reactive, onBeforeMount } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'vuex';
import EmptyList from './EmptyList.vue';
import BookList from './BookList.vue';
import AddBook from './AddBook.vue';
import Page from './Page.vue';

export default {
  name: 'Books',
  components: {
    AddBook,
    BookList,
    EmptyList,
    Page
  },
  setup() {
    const store = useStore();
    const listId = useRoute().query.id;

    const state = reactive({
      view: 'list',
      listId,
      list: computed(() => store.getters.list(listId)),
      books: computed(() => store.getters.booksForList(listId))
    });
    state.hasBooks = computed(() => !!state.books);
    state.showNew = computed(() => state.view === 'new');
    state.showList = computed(() => state.view === 'list');
    
    const showAddBookView = () => {
      state.view = 'new';
    };
    const closeAddBookView = () => {
      state.view = 'list';
    };

    onBeforeMount(() => store.dispatch('fetchBooks', state.listId));
    
    return {
      state,
      showAddBookView,
      closeAddBookView
    };
  }
};
</script>
