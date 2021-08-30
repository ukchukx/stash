<template>
  <!-- eslint-disable -->
  <div class="text-center px-6 py-4">
    <div class="py-8">
      <div class="mb-4">
        <EmptyListIcon />
      </div>
      <p class="text-2xl text-gray-600 font-medium mb-4">{{ message }}</p>
      <div v-if="showButton">
        <button 
          @click="addClicked"
          type="button" 
          class="bg-blue-600 hover:bg-blue-600 text-white border border-blue-600 rounded px-6 py-2">
          Add
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import EmptyListIcon from './EmptyListIcon.vue';

export default {
  name: 'EmptyList',
  components: {
    EmptyListIcon
  },
  props: {
    showButton: {
      type: Boolean,
      default: () => true
    },
    message: {
      type: String,
      default: () => 'You have no items'
    }
  },
  emits: ['add-item-clicked'],
  setup(props, { emit }) {
    const addClicked = () => {
      emit('add-item-clicked');
    };

    return {
      addClicked
    };
  }
};
</script>
