<template>
  <!-- eslint-disable -->
  <Page>
    <div class="px-4 py-3 relative my-2 bg-white p-4 flex flex-col justify-between leading-normal">
      <div class="grid grid-flow-row auto-rows-max">
        <div class="mx-auto">
          <MovieImage :thumbnail="movie.thumbnail" />
        </div>
        <div class="text-center">
          <p class="font-thin text-2xl my-2">{{ movie.title }}</p>
        </div>
      </div>

      <div class="w-full mt-2">
        <TagsInput v-model="form.tags" />
      </div>
    </div>
    <div class="px-4 py-3 relative bg-white p-4 flex flex-col justify-between leading-normal">
      <button v-if="showUpdateButton" @click="updateMovie" class="mt-2 btn-white btn mb-3">
        {{ updateButtonText }}
      </button>
    </div>
  </Page>
</template>
<script>
import { computed, reactive, ref } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';
import TagsInput from './TagsInput.vue';
import Page from './Page.vue';
import MovieImage from './MovieImage.vue';

export default {
  name: 'Movie',
  components: {
    Page,
    MovieImage,
    TagsInput
  },
  setup() {
    const store = useStore();
    const route = useRoute();
    const movieId = route.query.id;
    const listId = route.query.list;
    const busy = ref(false);
    const form = reactive({
      tags: []
    });

    const movie = computed(() => store.getters.movie(movieId));
    const updateButtonText = computed(() => busy.value ? 'Updating...' : 'Update');
    const showUpdateButton = computed(
      () => !movie.value ? false : form.tags !== movie.value.tags
    );

    store.dispatch('fetchMovies', listId)
      .then(() => {
        form.tags = movie.value.tags;
        form.notes = movie.value.notes;
      });

    const updateMovie = () => {
      if (busy.value) return;

      busy.value = true;
      store.dispatch('updateMovie', { ...form, id: movie.value.id })
        .finally(() => {
          busy.value = false;
        });
    };  

    return {
      movie,
      form,
      showUpdateButton,
      updateMovie,
      updateButtonText
    };
  }
};
</script>
