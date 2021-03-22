<template>
  <!-- eslint-disable -->
  <div>
    <div class="flex justify-between px-6">
      <div class="md:w-2/3 sm:w-0"></div>
      <div class="w-full md:w-1/3 flex items-center py-2">
        <input v-model="state.searchText" class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" placeholder="Search">
      </div>
    </div>
    <BookItem v-for="(book, i) in state.filteredBooks" :key="i" :book="book" />
    <EmptyList v-if="state.isEmpty" message="No books" :show-button="false" />
  </div>
</template>
<script>
import { computed, reactive } from 'vue';
import BookItem from './BookItem.vue';
import EmptyList from './EmptyList.vue';

export default {
  name: 'BookList',
  components: {
    BookItem,
    EmptyList
  },
  props: {
    books: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const showBook = ({ title, tags }, text) => {
      if (!text) return true;
      return title.toLowerCase().includes(text) || tags.some((t) => t.includes(text));
    };
    const state = reactive({
      searchText: ''
    });
    state.filteredBooks = computed(() => {
      const text = state.searchText.trim().toLowerCase();
      return props.books.filter((book) => showBook(book, text));
    });
    state.isEmpty = computed(() => !state.filteredBooks.length);

    return {
      state
    };
  }
};
</script>
