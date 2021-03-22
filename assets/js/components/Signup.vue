<template>
  <!-- eslint-disable -->
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 bg-blue-500">
    <div class="max-w-sm w-full">
      <AlertMessage :text="state.errorMessage" isError />
      <div class="w-full">
        <form  
          method="POST" 
          ref="form" 
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <CsrfToken />

          <Input 
            v-model="state.form.email"
            :validators="emailValidators"
            @errors="onEmailErrors"
            class="mb-4" 
            label="Email" 
            placeholder="Email" 
            type="text" 
            name="email"
            extraInputClasses="w-full" />
          
          <Input 
            v-model="state.form.password"
            :validators="passwordValidators"
            @errors="onPasswordErrors"
            class="mb-4" 
            label="Password" 
            placeholder="Password" 
            type="password"
            name="password"
            extraInputClasses="w-full" />
          
          <Input 
            v-model="state.form.passwordConfirmation"
            class="mb-2" 
            label="Password confirmation" 
            placeholder="Password confirmation" 
            type="password"
            extraInputClasses="w-full" />
          <p v-show="state.passwordMismatch" class="text-red-500 text-xs italic">Password values do not match</p>
          
          <div class="flex items-center justify-between mt-4">
            <button 
              v-if="!state.hasErrors"
              @click="submitForm"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" 
              type="button">
              Sign Up
            </button>
          </div>
          <a :href="state.signinPath" class="inline-block align-baseline font-bold text-sm text-blue-500">
            Have an account? Sign In
          </a>
        </form>
        <p class="text-center text-white text-xs">
          &copy;2020 Stash
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import { computed, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import Input from './Input.vue';
import AlertMessage from './AlertMessage.vue';
import CsrfToken from './CsrfToken.vue';
import { isEmail, minLength } from '../validators';

export default {
  name: 'Signup',
  components: {
    AlertMessage,
    CsrfToken,
    Input
  },
  setup() {
    const router = useRouter();
    const form = ref(null);
    const state = reactive({
      form: {
        email: '', 
        password: '',
        passwordConfirmation: '',
      },
      emailErrors: [],
      passwordErrors: [],
      passwordConfirmationErrors: [],
      signinPath: router.resolve({ name: 'Signin' }).href,
      errorMessage: ''
    });
    state.passwordMismatch = computed(() => state.form.password !== state.form.passwordConfirmation);
    state.hasErrors = computed(() => {
      const { form: { email, password }, passwordErrors, emailErrors } = state;
      const errors = emailErrors.concat(passwordErrors).length !== 0;

      return !email.trim() || !password.trim() || errors || state.passwordMismatch;
    });

    const emailValidators = [isEmail()];
    const passwordValidators = [minLength(8)];

    const onEmailErrors = (errors) => {
      state.emailErrors = errors;
    };
    const onPasswordErrors = (errors) => {
      state.passwordErrors = errors;
    };

    const submitForm = () => {
      state.errorMessage = '';
      axios.post('/signup', state.form)
      .then(({ data: { created } }) => {
        if (created) {
          router.push({ name: 'MovieLists' });
        } else {
          state.errorMessage = 'Could not create account';
        }
      })
      .catch(() => {
        state.errorMessage = 'Could not create account';
      });
    };

    return {
      emailValidators,
      passwordValidators,
      onEmailErrors,
      onPasswordErrors,
      state,
      submitForm,
      form
    };
  }
};
</script>
