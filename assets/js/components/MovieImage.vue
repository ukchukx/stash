<template>
  <img 
    class="rounded"
    v-if="isThumbnailPresent" 
    :src="thumbnail" 
    :width="width" 
    :height="height">
  <svg 
    v-else 
    :width="svgWidth" 
    :height="svgHeight" 
    class="fill-current text-gray-300" 
    xmlns="http://www.w3.org/2000/svg" 
    viewBox="0 0 25 25">
    <path fill-rule="evenodd" d="M20,5V3.799C20,3.357,19.643,3,19.201,3h-18.4C0.358,3,0,3.357,
      0,3.799V5h2v2H0v2h2v2H0v2h2v2H0v1.199 C0,16.641,0.358,17,0.801,17h18.4C19.643,17,20,16.641,20,16.199V15h-2v-2h2v-2h-2V9h2V7h-2V5H20z M8,13V7l5,3L8,13z"/>
  </svg>
</template>
<script>
import { computed } from 'vue';

export default {
  name: 'MovieImage',
  props: {
    thumbnail: {
      type: String,
      default: () => ''
    },
    height: {
      type: Number,
      default: () => 100
    },
    width: {
      type: Number,
      default: () => 100
    }
  },
  setup(props) {
    const isThumbnailPresent = computed(() => props.thumbnail && !!props.thumbnail.length);
    const svgWidth = `${props.width}px`;
    const svgHeight = `${props.height}px`;

    return {
      isThumbnailPresent,
      svgWidth,
      svgHeight
    };
  }
};
</script>
