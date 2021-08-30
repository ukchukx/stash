<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal">
    <span @click="onClose" class="absolute top-0 bottom-0 right-0 px-4 py-3">
      <svg class="ill-current h-6 w-6 text-black-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
    </span>
    <Input 
      :focus="true"
      label="Title" 
      @enter-pressed="searchForBooks" 
      placeholder="Title" 
      extraInputClasses="w-full" 
      v-model="state.form.title" />
    <button 
      @click="searchForBooks"
      :disabled="state.disableSearchButton"
      class="btn-white btn mb-3">
      {{ state.buttonText }}
    </button>
    <div v-show="!state.fetchingDetails">
      <div 
        v-show="state.noBooksSelected"
        @click="bookSelected(i)"
        :key="i" v-for="(book, i) in state.options" 
        class="flex-grow flex px-4 py-2 items-center border-b cursor-pointer">
        <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
          <img :src="book.thumbnail" width="50" height="50">
        </div>
        <div class="flex w-3/5 md:w3/4 text-gray-600">
          <span>
            {{ book.title }}
          </span>
        </div>
      </div>
      
      <p v-show="state.showNoResultsMessage">No books found</p>
    </div>

    <h4 v-show="state.fetchingDetails" class="italic">Fetching details...</h4>

    <div v-show="state.bookSelected" class="flex flex-col">
      <img class="mb-2 mt-2" v-show="state.hasThumbnail" :src="state.form.thumbnail" width="150" height="150">
      <button @click="saveBook" class="btn btn-blue mt-3">Save</button>
    </div>
  </div>
</template>
<script>
import { computed, reactive } from 'vue';
import { useStore } from 'vuex';
import axios from 'axios';
import Input from './Input.vue';

export default {
  name: 'AddBook',
  components: {
    Input
  },
  props: {
    listId: {
      type: String,
      required: true
    }
  },
  emits: ['closed'],
  setup(props, { emit }) {
    const store = useStore();
    const currentYear = new Date().getFullYear();
    const bookSearchBaseUrl = 'https://www.googleapis.com/books/v1/volumes?fields=items(volumeInfo(title,imageLinks(thumbnail),industryIdentifiers))&q=title:';
    let timeout;
    const state = reactive({
      options: [],
      searching: false,
      searched: false,
      bookSelected: false,
      form: {
        title: '',
        isbn: '',
        list_id: props.listId,
        thumbnail: null
      }
    });
    state.disableSearchButton = computed(() => !state.form.title.length || state.searching);
    state.buttonText = computed(() => state.searching ? 'Searching...' : 'Search');
    state.hasThumbnail = computed(() => state.form.thumbnail && state.form.thumbnail.length > 0);
    state.showNoResultsMessage = computed(
      () => state.searched && !state.options.length && !state.searching
    );
    state.noBooksSelected = computed(() => !!state.options.length && !state.bookSelected);

    const getIsbn = (identifiers) => {
      if (!identifiers || !identifiers.length) return '';
      const findIsbn13 = ({ type }) => type === 'ISBN_13';
      const findIsbn10 = ({ type }) => type === 'ISBN_10';
      let record = identifiers.find(findIsbn13);
      if (!record) record = identifiers.find(findIsbn10);

      return record ? record.identifier : null;
    };

    const searchForBooks = () => {
      if (timeout) clearTimeout(timeout);

      timeout = setTimeout(() => {
        state.searching = true;
        state.searched = false;
        state.bookSelected = false;
        state.options = [];
        axios
          .get(`${bookSearchBaseUrl}${state.form.title.trim()}`)
          .then(({ data: { items } }) => {
            state.options = items
              .map(({ volumeInfo }) => {
                const { title, imageLinks, industryIdentifiers } = volumeInfo;
                const thumbnail = imageLinks && imageLinks.thumbnail ? imageLinks.thumbnail : null;
                return { title, thumbnail, isbn: getIsbn(industryIdentifiers) };
              })
              .filter(({ isbn }) => !!isbn);
          })
          .catch((response) => {
            console.warn('error', response);
            state.options = [];
          })
          .finally(() => {
            state.searching = false;
            state.searched = true;
          });
      }, 500);
    };
    const onClose = () => emit('closed');

    const bookSelected = (index) => {
      const book = state.options[index];
      state.form.title = book.title;
      state.form.thumbnail = book.thumbnail;
      state.form.isbn = book.isbn;
      state.bookSelected = true;
    };

    const saveBook = () => {
      store.dispatch('createBook', state.form)
        .then(() => {
          onClose();
        });
    };

    return {
      state,
      onClose,
      bookSelected,
      searchForBooks,
      saveBook
    };
  }
};
</script>
