<template>
  <!-- eslint-disable -->
  <div class="mb-4">
    <label class="block text-gray-700 text-sm font-bold mb-2">
      {{ label }}
    </label>
    <input
      @keyup.enter="enterPressed"
      v-model="input"
      :name="name"
      :class="classes" 
      :type="type" 
      :placeholder="placeholder">
    <InputErrors v-show="showErrors" :errors="errors" class="mt-2" />
  </div>
</template>
<script>
import { computed, watch } from 'vue';
import useInputValidator from '../features/useInputValidator';
import InputErrors from './InputErrors.vue';

export default {
  name: 'Input',
  components: {
    InputErrors
  },
  props: {
    placeholder: {
      type: String,
      default: () => ''
    },
    type: {
      type: String,
      default: () => 'text'
    },
    label: {
      type: String,
      default: () => ''
    },
    extraInputClasses: {
      type: String,
      default: () => ''
    },
    validators: {
      type: Array,
      default: () => []
    },
    modelValue: {
      type: String,
      default: () => ''
    },
    name: {
      type: String,
      default: () => ''
    },
    showErrors: {
      type: Boolean,
      default: () => true
    }
  },
  emits: ['update:modelValue', 'errors', 'enter-pressed'],
  setup(props, { emit }) {
    const { input, errors } = useInputValidator(
      props.value, 
      props.validators, 
      (value) => emit('update:modelValue', value)
    );
    const enterPressed = () => emit('enter-pressed');
    
    let defaultClasses = `shadow appearance-none border rounded py-2 px-3 text-gray-700 ${props.extraInputClasses}`;
    defaultClasses = `${defaultClasses} focus:outline-none leading-tight`;
    const nonErrorClasses = `${defaultClasses} focus:shadow-outline`;
    const errorClasses = `${defaultClasses} border-red-500`;

    const classes = computed(() => errors.value.length && props.showErrors ? errorClasses : nonErrorClasses);

    watch(
      () => errors.value,
      (newVal) => emit('errors', newVal),
      { immediate: true }
    );

    watch(
      () => props.value,
      (newVal) => {
        if (newVal !== input.value) input.value = newVal;
      },
      { immediate: true }
    );

    return {
      input,
      errors,
      classes,
      enterPressed
    };
  }
};
</script>
