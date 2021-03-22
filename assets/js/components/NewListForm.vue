<template>
  <!-- eslint-disable -->
  <form class="w-full">
    <div class="flex items-center py-2">
      <input 
        class="appearance-none bg-transparent border-b border-blue-500 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
        type="text" 
        v-model="state.form.name"
        @keyup.enter="addList"
        :placeholder="placeholder">
        
      <button 
        @click="addList"
        :disabled="!state.canAddList"
        class="flex-shrink-0 bg-blue-500 border-blue-500 text-sm border-4 text-white py-1 px-2 rounded" 
        type="button">
        Create
      </button>
    </div>
  </form>
</template>
<script>
import { computed, reactive } from 'vue';
import { useStore } from 'vuex';
import List from './List.vue';

export default {
  name: 'NewListForm',
  components: {
    List
  },
  props: {
    placeholder: {
      type: String,
      default: () => 'List name'
    },
    listType: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const store = useStore();
    const state = reactive({
      form: {
        name: '',
        type: props.listType
      }
    });
    state.canAddList = computed(() => !!state.form.name);

    const addList = () => {
      store.dispatch('createList', state.form)
        .then(() => {
          state.form.name = '';
        });
    };

    return {
      state,
      addList
    };
  }
};
</script>
