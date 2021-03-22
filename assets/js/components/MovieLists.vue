<template>
  <!-- eslint-disable -->
  <Page>
    <Lists :lists="movieLists" list-type="movie" />
    <EmptyList v-if="isEmpty" message="You have no movie lists" />
  </Page>
</template>
<script>
import { computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import EmptyList from './EmptyList.vue';
import Lists from './Lists.vue';
import Page from './Page.vue';

export default {
  name: 'MovieLists',
  components: {
    EmptyList,
    Lists,
    Page
  },
  setup() {
    const store = useStore();
    const movieLists = computed(() => store.getters.movieLists);
    const isEmpty = computed(() => !movieLists.value.length);

    onBeforeMount(() => store.dispatch('fetchLists'));

    return {
      movieLists,
      isEmpty
    };
  }
};
</script>
