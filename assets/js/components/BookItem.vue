<template>
  <!-- eslint-disable -->
  <div class="flex-grow flex px-4 py-2 items-center border-b">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <a :href="bookHref">
        <img v-if="hasThumbnail" :src="book.thumbnail" width="150" height="150">
        <svg v-else width="150px" height="150px" class="fill-current text-gray-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><path d="M17,5.95v10.351c0,0.522-0.452,0.771-1,1.16c-0.44,0.313-1-0.075-1-0.587c0,0,0-9.905,0-10.114
          c0-0.211-0.074-0.412-0.314-0.535C14.446,6.102,6.948,2.16,6.948,2.16C6.827,2.115,6.299,1.782,5.595,2.144
          C4.926,2.488,4.562,2.862,4.469,3.038l8.18,4.482C12.866,7.634,13,7.81,13,8.036v10.802c0,0.23-0.142,0.476-0.369,0.585
          c-0.104,0.052-0.219,0.077-0.333,0.077c-0.135,0-0.271-0.033-0.386-0.104c-0.215-0.131-7.774-4.766-8.273-5.067
          c-0.24-0.144-0.521-0.439-0.527-0.658L3,3.385c0-0.198-0.023-0.547,0.289-1.032c0.697-1.084,3.129-2.317,4.36-1.678l8.999,4.555
          C16.865,5.342,17,5.566,17,5.95z" fill-rule="nonzero"/></svg>
      </a>
    </div>
    <div class="flex w-3/5 md:w3/4 text-gray-600">
      <span>
        {{ book.title }}
      </span>
      <a href="#" @click="deleteBook" class="ml-auto">
        <svg class="inline-block fill-current text-gray-400 h-8 w-8" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
          <path d="M3.389,7.113L4.49,18.021C4.551,18.482,6.777,19.998,10,20c3.225-0.002,5.451-1.518,5.511-1.979
            l1.102-10.908C14.929,8.055,12.412,8.5,10,8.5C7.59,8.5,5.072,8.055,3.389,7.113z M13.168,1.51l-0.859-0.951
            C11.977,0.086,11.617,0,10.916,0H9.085c-0.7,0-1.061,0.086-1.392,0.559L6.834,1.51C4.264,1.959,2.4,3.15,2.4,4.029v0.17
            C2.4,5.746,5.803,7,10,7c4.198,0,7.601-1.254,7.601-2.801v-0.17C17.601,3.15,15.738,1.959,13.168,1.51z M12.07,4.34L11,3H9
            L7.932,4.34h-1.7c0,0,1.862-2.221,2.111-2.522C8.533,1.588,8.727,1.5,8.979,1.5h2.043c0.253,0,0.447,0.088,0.637,0.318
            C11.907,2.119,13.77,4.34,13.77,4.34H12.07z"/>
        </svg>
      </a>
    </div>
  </div>
</template>
<script>
import { computed, ref } from '@vue/composition-api';
import eventBus from '@/eventBus';

export default {
  name: 'BookItem',
  props: {
    book: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const bookHref = computed(() => `/b/${props.book.id}`);
    const hasThumbnail = ref(props.book.thumbnail && !!props.book.thumbnail.length);

    const deleteBook = () => {
      if (confirm('Sure?')) eventBus.$emit('book-deleted', props.book.id);
    };

    return {
      bookHref,
      hasThumbnail,
      deleteBook
    };
  }
};
</script>
