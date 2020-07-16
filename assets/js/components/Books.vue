<template>
  <!-- eslint-disable -->
  <div> 
    <div v-show="showList">
      <button v-show="hasBooks" class="btn btn-white ml-4 my-3 w-20" @click="showAddBookView">Add</button>
      <BookList v-show="hasBooks" :books="state.books" />
      <EmptyList v-show="!hasBooks" resource="books" @add-book="showAddBookView" />
    </div>
    <div v-show="showNew">
      <AddBook @book-added="bookAdded" @closed="closeAddBookView" />
    </div>
  </div>
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import EmptyList from '@/components/EmptyList';
import BookList from '@/components/BookList';
import AddBook from '@/components/AddBook';
import eventBus from '@/eventBus';

export default {
  name: 'Books',
  components: {
    AddBook,
    BookList,
    EmptyList
  },
  props: {
    initialBooks: {
      type: Array,
      default: () => []
    }
  },
  setup(props) {
    const state = reactive({
      books: props.initialBooks,
      view: 'list'
    });
    const hasBooks = computed(() => !!state.books.length);
    const showList = computed(() => state.view === 'list');
    const showNew = computed(() => state.view === 'new');
    
    const showAddBookView = () => {
      state.view = 'new';
    };
    const closeAddBookView = () => {
      state.view = 'list';
    };
    const bookAdded = (book) => {
      state.books.push(book);
    };

    eventBus.$on('book-deleted', (bookId) => {
      state.books = state.books.filter(({ id }) => id !== bookId);
    });
    
    return {
      state,
      hasBooks,
      showAddBookView,
      closeAddBookView,
      showList,
      showNew,
      bookAdded
    };
  }
};
</script>
