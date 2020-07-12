<template>
  <!-- eslint-disable -->
  <BookList v-if="hasBooks" :books="books" />
  <EmptyList v-else resource="books" @add-book="addBook" />
</template>
<script>
import { computed, ref } from '@vue/composition-api';
import EmptyList from '@/components/EmptyList';
import BookList from '@/components/BookList';
import eventBus from '@/eventBus';

export default {
  name: 'Books',
  components: {
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
    const books = ref(props.initialBooks);
    const hasBooks = computed(() => !!books.value.length);
    const addBook = () => true;

    eventBus.$on('book-deleted', (bookId) => {
      books.value = books.value.filter(({ id }) => id !== bookId);
    });
    
    return {
      books,
      hasBooks,
      addBook
    };
  }
};
</script>
