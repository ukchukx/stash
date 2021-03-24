<template>
  <!-- eslint-disable -->
  <Page>
    <div class="px-4 py-3 relative my-2 bg-white p-4 flex flex-col justify-between leading-normal">
      <div class="grid grid-flow-row auto-rows-max">
        <div class="mx-auto">
          <BookImage :thumbnail="book.thumbnail" />
        </div>
        <div class="text-center">
          <p class="font-thin text-2xl my-2">{{ book.title }}</p>
        </div>
      </div>

      <div class="w-full mt-2">
        <TagsInput v-model="form.tags" />
      </div>
      <div class="w-full mt-2">
        <quill-editor
          v-model:value="form.notes"
          :options="editorOptions"
        />
      </div>
    </div>
    <div class="px-4 py-3 relative bg-white p-4 flex flex-col justify-between leading-normal">
      <button v-if="showUpdateButton" @click="updateBook" class="mt-2 btn-white btn mb-3">
        {{ updateButtonText }}
      </button>
    </div>
  </Page>
</template>
<script>
import { computed, reactive, ref } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';
import { quillEditor } from 'vue3-quill';
import TagsInput from './TagsInput.vue';
import Page from './Page.vue';
import BookImage from './BookImage.vue';

export default {
  name: 'Book',
  components: {
    Page,
    BookImage,
    TagsInput,
    quillEditor
  },
  setup() {
    const store = useStore();
    const route = useRoute();
    const editorOptions = {
      placeholder: 'Notes...'
    };
    const bookId = route.query.id;
    const listId = route.query.list;
    const busy = ref(false);
    const form = reactive({
      notes: '',
      tags: []
    });

    const book = computed(() => store.getters.book(bookId));
    const updateButtonText = computed(() => busy.value ? 'Updating...' : 'Update');
    const showUpdateButton = computed(
      () => !book.value ? false : form.notes !== book.value.notes || form.tags !== book.value.tags
    );

    store.dispatch('fetchBooks', listId)
      .then(() => {
        form.tags = book.value.tags;
        form.notes = book.value.notes;
      });

    const updateBook = () => {
      if (busy.value) return;

      busy.value = true;
      store.dispatch('updateBook', { ...form, id: book.value.id })
        .finally(() => {
          busy.value = false;
        });
    };  

    return {
      book,
      form,
      showUpdateButton,
      updateBook,
      editorOptions,
      updateButtonText
    };
  }
};
</script>
