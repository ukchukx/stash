<template>
  <!-- eslint-disable -->
  <div class="text-center px-6 py-4">
    <div class="py-8">
      <h5 class="py-8">{{ user.email }}</h5>
      <div>
        <a 
          href="/signout"
          class="bg-blue-600 hover:bg-blue-600 text-white border border-blue-600 rounded px-6 py-2">
          Sign out
        </a>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'Account',
  props: {
    user: {
      type: Object,
      required: true
    }
  }
};
</script>
