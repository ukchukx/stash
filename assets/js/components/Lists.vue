<template>
  <!-- eslint-disable -->
  <div class="flex justify-between px-6">
    <ListForm :list-type="listType" />
  </div>

  <List v-for="(list, i) in lists" :key="i" :list="list" />
</template>
<script>
import { computed, reactive } from 'vue';
import List from './List.vue';
import ListForm from './ListForm.vue';

export default {
  name: 'Lists',
  components: {
    List,
    ListForm
  },
  props: {
    lists: {
      type: Array,
      required: true
    },
    listType: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const state = reactive({
      form: {
        name: '',
        type: props.listType
      }
    });
    state.canAddList = computed(() => !!state.form.name);

    const addList = () => {};

    return {
      state,
      addList
    };
  }
};
</script>
