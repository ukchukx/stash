<template>
  <!-- eslint-disable -->
  <div class="flex-grow flex px-4 py-2 items-center border-b">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <a :href="movieHref">
        <img v-if="hasThumbnail" :src="movie.thumbnail" width="100" height="100">
        <svg v-else width="100px" height="100px" class="fill-current text-gray-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><path fill-rule="evenodd" d="M20,5V3.799C20,3.357,19.643,3,19.201,3h-18.4C0.358,3,0,3.357,
          0,3.799V5h2v2H0v2h2v2H0v2h2v2H0v1.199 C0,16.641,0.358,17,0.801,17h18.4C19.643,17,20,16.641,20,16.199V15h-2v-2h2v-2h-2V9h2V7h-2V5H20z M8,13V7l5,3L8,13z"/></svg>
      </a>
    </div>
    <div class="flex w-3/5 md:w3/4 text-gray-600">
      <a :href="movieHref">
        {{ movie.title }}
      </a>
      <a href="javascript:;" @click="deleteMovie" class="ml-auto">
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

export default {
  name: 'MovieItem',
  components: {
    DeleteIcon
  },
  props: {
    movie: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const store = useStore();
    const router = useRouter();
    const movieHref = router.resolve({ name: 'Movie', query: { id: props.movie.id } }).href;
    const hasThumbnail = ref(props.movie.thumbnail && !!props.movie.thumbnail.length);

    const deleteMovie = () => {
      if (!confirm('Sure?')) return;

      store.dispatch('deleteMovie', props.movie.id);
    };

    return {
      movieHref,
      hasThumbnail,
      deleteMovie
    };
  }
};
</script>
