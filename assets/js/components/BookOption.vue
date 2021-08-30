<template>
  <div class="flex-grow flex px-4 py-2 items-center border-b cursor-pointer">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <BookImage 
        :thumbnail="item.thumbnail" 
        :width="150" 
        :height="150" />
    </div>
    <div class="flex w-3/5 md:w3/4 text-gray-600">
      <span>
        {{ item.title }}
      </span>
    </div>
  </div>
</template>
<script>
import BookImage from './BookImage.vue';

export default {
  name: 'BookOption',
  components: {
    BookImage
  },
  props: {
    item: {
      type: Object,
      required: true
    }
  }
};
</script>
