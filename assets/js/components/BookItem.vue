<template>
  <!-- eslint-disable -->
  <div class="flex-grow flex px-4 py-2 items-center border-b">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <a :href="bookHref">
        <BookImage :thumbnail="book.thumbnail" />
      </a>
    </div>
    <div class="flex w-3/5 md:w3/4 text-gray-600">
      <a :href="bookHref">
        {{ book.title }}
      </a>
      <a href="javascript:;" @click="deleteBook" class="ml-auto">
        <DeleteIcon />
      </a>
    </div>
  </div>
</template>
<script>
import { ref } from 'vue';
import { useStore } from 'vuex';
import { useRouter } from 'vue-router';
import DeleteIcon from './DeleteIcon.vue';
import BookImage from './BookImage.vue';

export default {
  name: 'BookItem',
  components: {
    DeleteIcon,
    BookImage
  },
  props: {
    book: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const store = useStore();
    const router = useRouter();
    const bookHref = router.resolve({ 
      name: 'Book', 
      query: { id: props.book.id, list: props.book.list_id } 
    }).href;
    const hasThumbnail = ref(props.book.thumbnail && !!props.book.thumbnail.length);

    const deleteBook = () => {
      if (!confirm('Sure?')) return;

      store.dispatch('deleteBook', props.book.id);
    };

    return {
      bookHref,
      hasThumbnail,
      deleteBook
    };
  }
};
</script>
