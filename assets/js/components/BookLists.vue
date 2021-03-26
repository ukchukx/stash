<template>
  <!-- eslint-disable -->
  <Page>
    <Lists :lists="bookLists" list-type="book" />
    <EmptyList v-if="isEmpty" message="You have no book lists" />
  </Page>
</template>
<script>
import { computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import EmptyList from './EmptyList.vue';
import Lists from './Lists.vue';
import Page from './Page.vue';

export default {
  name: 'BookLists',
  components: {
    EmptyList,
    Lists,
    Page
  },
  setup() {
    const store = useStore();
    const bookLists = computed(() => store.getters.bookLists);
    const isEmpty = computed(() => !bookLists.value.length);

    onBeforeMount(() => store.dispatch('fetchLists'));

    return {
      bookLists,
      isEmpty
    };
  }
};
</script>
