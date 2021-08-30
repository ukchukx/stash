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

      <select 
        class="appearance-none bg-transparent border-b border-blue-500 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
        v-model="state.form.type">
        <option value="movie">Movie</option>
        <option value="book">Book</option>
      </select>
        
      <button 
        @click="addList"
        :disabled="!state.canAddList"
        class="flex-shrink-0 bg-blue-500 border-blue-500 text-sm border-4 text-white py-1 px-2 rounded" 
        type="button">
        {{ state.buttonText }}
      </button>
    </div>
  </form>
</template>
<script>
import { computed, reactive } from 'vue';
import { useStore } from 'vuex';
import List from './List.vue';

export default {
  name: 'ListForm',
  components: {
    List
  },
  props: {
    placeholder: {
      type: String,
      default: () => 'List name'
    },
    list: {
      type: Object,
      default: () => ({})
    }
  },
  setup(props) {
    const store = useStore();
    const state = reactive({
      form: {
        name: '',
        type: 'movie',
        id: props.list.id,
        name: props.list.name || ''
      }
    });
    state.nameUsed = computed(() => store.getters.lists.some(({ name }) => name === state.form.name));
    state.canAddList = computed(() => !!state.form.name && !state.nameUsed);
    state.buttonText = computed(() => props.list.id ? 'Update' : 'Create');
    state.command = computed(() => props.list.id ? 'updateList' : 'createList');

    const addList = () => {
      store.dispatch(state.command, state.form)
        .then(() => {
          if (!state.form.id) state.form.name = '';
        });
    };

    return {
      state,
      addList
    };
  }
};
</script>
