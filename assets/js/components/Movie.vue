<template>
  <!-- eslint-disable -->
  <Page>
    <div class="px-4 py-3 relative my-2 bg-white p-4 flex flex-col justify-between leading-normal">
      <div class="grid grid-flow-row auto-rows-max">
        <div class="mx-auto">
          <MovieImage 
            :width="250"
            :height="250"
            :thumbnail="state.movie.thumbnail" />
        </div>
        <div class="text-center">
          <p class="font-thin text-2xl my-2">{{ state.movie.title }}</p>
        </div>
      </div>

      <div class="w-full mt-2">
        <TagsInput v-model="state.form.tags" />
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
import { computed, reactive } from 'vue';
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
    const listId = route.query.list;
    const state = reactive({
      busy: false,
      form: {
        id: route.query.id,
        tags: []
      }
    });

    state.movie = computed(() => store.getters.movie(state.form.id));
    const updateButtonText = computed(() => state.busy ? 'Updating...' : 'Update');
    const showUpdateButton = computed(
      () => !state.movie ? false : state.form.tags !== state.movie.tags
    );

    store.dispatch('fetchMovies', listId)
      .then(() => {
        state.form.tags = state.movie.tags;
        state.form.notes = state.movie.notes;
      });

    const updateMovie = () => {
      if (state.busy) return;

      state.busy = true;
      store.dispatch('updateMovie', { ...state.form })
        .finally(() => {
          state.busy = false;
        });
    };  

    return {
      state,
      showUpdateButton,
      updateMovie,
      updateButtonText
    };
  }
};
</script>
