<template>
  <!-- eslint-disable -->
  <div class="px-4 py-2 items-center">
    <div>
      <a :href="movieHref">
        <MovieImage :thumbnail="movie.thumbnail" :width="250" :height="250" />
      </a>
    </div>
    <div class="mt-2 text-center text-gray-600">
      <a :href="movieHref" class="truncate">
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
