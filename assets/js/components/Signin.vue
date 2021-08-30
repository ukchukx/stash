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
          <CsrfToken v-model="state.form._csrf_token" />

          <Input 
            v-model="state.form.email"
            :validators="emailValidators"
            @errors="onEmailErrors"
            :showErrors="false"
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
            :showErrors="false"
            class="mb-6" 
            label="Password" 
            placeholder="Password" 
            type="password"
            name="password"
            extraInputClasses="w-full" />
          
          <div class="flex items-center justify-between">
            <button 
              v-if="!state.hasErrors"
              @click="submitForm"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" 
              type="button">
              Sign In
            </button>
            <a class="inline-block align-baseline font-bold text-sm text-blue-500 hover:text-blue-800" href="#">
              Forgot Password?
            </a>
          </div>
          <a :href="state.signupPath" class="inline-block align-baseline font-bold text-sm text-blue-500">
            Don't have an account? Sign Up
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
  name: 'Signin',
  components: {
    AlertMessage,
    CsrfToken,
    Input
  },
  setup() {
    const router = useRouter();
    const form = ref(null);
    const emailValidators = [isEmail()];
    const passwordValidators = [minLength(8)];
    const state = reactive({
      form: {
        email: '', 
        password: '',
        _csrf_token: ''
      },
      emailErrors: [],
      passwordErrors: [],
      signupPath: router.resolve({ name: 'Signup' }).href,
      errorMessage: ''
    });
    state.hasErrors = computed(() => {
      const { form: { email, password }, passwordErrors, emailErrors } = state;
      const errors = emailErrors.concat(passwordErrors).length !== 0;

      return !email.trim() || !password.trim() || errors;
    });

    const onEmailErrors = (errors) => {
      state.emailErrors = errors;
    };
    const onPasswordErrors = (errors) => {
      state.passwordErrors = errors;
    };

    const submitForm = () => { 
      state.errorMessage = '';
      axios.post('/api/signin', state.form)
      .then(({ data: { authenticated } }) => {
        if (authenticated) {
          router.push({ name: 'Lists' });
        } else {
          state.errorMessage = 'Invalid email/password';
        }
      })
      .catch(() => {
        state.errorMessage = 'Invalid email/password';
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
