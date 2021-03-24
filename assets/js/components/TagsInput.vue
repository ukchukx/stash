<template v-once>
  <label for="tags" class="block text-sm font-medium text-gray-700">Tags</label>
  <div class="mt-1 relative rounded-md shadow-sm">
    <input ref="el" :value="tags" @change="onChange">
  </div>
</template>
<script>
import Tagify from '@yaireo/tagify/dist/tagify.min.js';
import '@yaireo/tagify/dist/tagify.css';
import { onMounted, ref, watch } from 'vue';

export default {
  name: 'TagsInput',
  props: {
    modelValue: {
      type: Array,
      default: () => []
    }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    let tagify;
    const initialized = ref(false);
    const el = ref(null);
    const tags = ref(props.modelValue);

    const strToArray = (tagsStr) => tagsStr.startsWith('[') ? JSON.parse(tagsStr) : tagsStr.split(',');

    const onChange = (e) => {
      let updatedValue = e.target.value || [];
      updatedValue = typeof updatedValue === 'string' ? strToArray(updatedValue) : updatedValue;
      updatedValue = updatedValue.map(({ value }) => value);
      tags.value = updatedValue;
      emit('update:modelValue', updatedValue);
    };

    watch(
      () => props.modelValue,
      (newVal) => {
        if (initialized.value) return; 

        tags.value = newVal;
        if (tagify) tagify.loadOriginalValues(tags.value);
        initialized.value = true;
      }
    );

    onMounted(() => {
      tagify = new Tagify(el.value);
      tagify.loadOriginalValues(tags.value);
    });

    return {
      el,
      tags,
      onChange
    };
  }
};
</script>
