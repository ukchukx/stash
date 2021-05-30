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
import ListForm from './ListForm.vue';
import CloseButton from './CloseButton.vue';

export default {
  name: 'Books',
  components: {
    AddBook,
    BookList,
    EmptyList,
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
    state.hasBooks = computed(() => !!state.books);
    state.showNew = computed(() => state.view === 'new');
    state.showList = computed(() => state.view === 'list');
    state.list = computed(() => store.getters.list(listId));
    state.books = computed(() => store.getters.booksForList(listId));
    
    const showAddBookView = () => {
      state.view = 'new';
    };
    const closeAddBookView = () => {
      state.view = 'list';
    };
    const toggleTitleForm = () => {
      state.showForm = !state.showForm;
    };
    const onClose = () => {
      state.showForm = false;
    };

    onBeforeMount(() => store.dispatch('fetchBooks', listId));
    
    return {
      state,
      showAddBookView,
      closeAddBookView,
      toggleTitleForm,
      onClose
    };
  }
};
</script>
