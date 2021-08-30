<template>
  <!-- eslint-disable -->
  <Page>
    <div class="flex justify-between px-6">
      <NewListForm />
    </div>

    <List v-for="(list, i) in lists" :key="i" :list="list" />

    <EmptyList v-if="isEmpty" message="You have no lists" />
  </Page>
</template>
<script>
import { computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import EmptyList from './EmptyList.vue';
import Page from './Page.vue';
import List from './List.vue';
import NewListForm from './NewListForm.vue';

export default {
  name: 'Lists',
  components: {
    EmptyList,
    List,
    NewListForm,
    Page
  },
  setup() {
    const store = useStore();
    const lists = computed(() => store.getters.lists);
    const isEmpty = computed(() => !lists.value.length);

    onBeforeMount(() => store.dispatch('fetchLists'));

    return {
      lists,
      isEmpty
    };
  }
};
</script>
