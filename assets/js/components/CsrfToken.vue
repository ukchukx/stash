<template>
  <!-- eslint-disable -->
  <input type="hidden" name="_csrf_token" :value="csrfToken">
</template>
<script>
import { onMounted, ref } from 'vue';

export default {
  name: 'CsrfToken',
  props: {
    modelValue: {
      type: String,
      default: () => ''
    }
  },
  emits: ['update:modelValue'],
  setup(_props, { emit }) {
    const csrfToken = ref('');

    onMounted(() => {
      const meta = document.head.querySelector('meta[name="csrf-token"]');
      if (meta) {
        csrfToken.value = meta.content;
        emit('update:modelValue', meta.content);
      }
    });

    return {
      csrfToken
    };
  }
};
</script>
