<template>
  <!-- eslint-disable -->
  <div class="flex-grow flex px-4 py-2 items-center border-b">
    <div class="w-2/5 xl:w-1/4 px-4 flex items-center">
      <a :href="movieHref">
        <MovieImage :thumbnail="movie.thumbnail" />
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
import MovieImage from './MovieImage.vue';

export default {
  name: 'MovieItem',
  components: {
    DeleteIcon,
    MovieImage
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
    const movieHref = router.resolve({
      name: 'Movie', 
      query: { id: props.movie.id, list: props.movie.list_id } 
    }).href;
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
