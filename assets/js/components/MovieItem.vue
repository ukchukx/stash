<template>
  <!-- eslint-disable -->
  <div class="flex-grow flex px-4 py-2 items-center border-b">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <a :href="movieHref">
        <img v-if="hasThumbnail" :src="movie.thumbnail" width="150" height="150">
        <svg v-else width="150px" height="150px" class="fill-current text-gray-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><path fill-rule="evenodd" d="M20,5V3.799C20,3.357,19.643,3,19.201,3h-18.4C0.358,3,0,3.357,
          0,3.799V5h2v2H0v2h2v2H0v2h2v2H0v1.199 C0,16.641,0.358,17,0.801,17h18.4C19.643,17,20,16.641,20,16.199V15h-2v-2h2v-2h-2V9h2V7h-2V5H20z M8,13V7l5,3L8,13z"/></svg>
      </a>
    </div>
    <div class="flex w-3/5 md:w3/4 text-gray-600">
      <span>
        {{ movie.title }}
      </span>
      <a href="#" @click="deleteMovie" class="ml-auto">
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
import axios from 'axios';
import { computed, ref } from '@vue/composition-api';
import eventBus from '@/eventBus';

export default {
  name: 'MovieItem',
  props: {
    movie: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const movieHref = computed(() => `/m/${props.movie.id}`);
    const hasThumbnail = ref(props.movie.thumbnail && !!props.movie.thumbnail.length);

    const deleteMovie = () => {
      if (!confirm('Sure?')) return;

      axios.delete(`/movies/${props.movie.id}`)
        .then(() => {
          eventBus.$emit('movie-deleted', props.movie.id);
        });
    };

    return {
      movieHref,
      hasThumbnail,
      deleteMovie
    };
  }
};
</script>
