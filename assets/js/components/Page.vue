<template>
  <!-- eslint-disable -->
  <div class="font-sans bg-gray-lighter flex flex-col min-h-screen w-full">
    <TopBar :username="state.username" />

    <div class="h-screen flex-grow container mx-auto pb-8">
       <div class="flex flex-wrap pb-24">
        <div class="w-full flex flex-col">
          <div class="flex-grow flex flex-col bg-white overflow-hidden">
            <slot />
          </div>
        </div>
       </div>
      <BottomBar />
    </div>
  </div>
</template>
<script>
import { computed, reactive } from 'vue';
import { useStore } from 'vuex';
import TopBar from './TopBar.vue';
import BottomBar from './BottomBar.vue';

export default {
  name: 'Page',
  components: {
    BottomBar,
    TopBar
  },
  props: {
    username: {
      type: String,
      default: () => 'Guest'
    }
  },
  setup() {
    const store = useStore();
    const guest = { email: 'Guest' };
    const state = reactive({
      username: computed(() => (store.getters.user || guest).email)
    });

    return {
      state
    };
  }
};
</script>
