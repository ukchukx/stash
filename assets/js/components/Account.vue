<template>
  <!-- eslint-disable -->
  <Page>
    <div class="text-center px-6 py-4">
      <div class="py-8">
        <div>
          <a 
            href="/signout"
            class="bg-blue-600 hover:bg-blue-600 text-white border border-blue-600 rounded px-6 py-2">
            Sign out
          </a>
        </div>
      </div>
    </div>
  </Page>
</template>
<script>
import Page from './Page.vue';

export default {
  name: 'Account',
  components: {
    Page
  }
};
</script>
