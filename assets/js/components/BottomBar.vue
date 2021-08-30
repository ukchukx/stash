<template>
  <!-- eslint-disable -->
  <div class="fixed bottom-0 inset-x-0 bg-white h-24 w-full">
    <div class="block w-full">
      <div class="container mx-auto">
        <div class="flex items-stretch">
          <div class="flex mx-auto">
            <a @click="selectLists" href="javascript:;" :class="state.listClasses">
              <ListIcon />
              <span class="text-sm md:text-md">Lists</span>
            </a>
          </div>
          <div class="flex mx-auto">
            <a @click="selectAccounts" href="javascript:;" :class="state.accountClasses">
              <AccountIcon />
              <span class="text-sm md:text-md">Account</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { reactive, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import AccountIcon from './AccountIcon.vue';
import ListIcon from './ListIcon.vue';

export default {
  name: 'BottomBar',
  components: {
    AccountIcon,
    ListIcon
  },
  setup() {
    const route = useRoute();
    const router = useRouter();
    
    const commonClasses = 'no-underline inline-block text-center py-4 border-b';
    let defaultClasses = 'opacity-50 text-gray-600 md:opacity-100 border-transparent hover:opacity-100';
    defaultClasses = `md:hover:border-gray-600 ${defaultClasses} ${commonClasses}`;
    const activeClasses = `text-blue-600 border-blue-600 ${commonClasses}`;
    const listsRoute = 'Lists';
    const accountRoute = 'Account';

    const listsSelected = computed(() => route.name === listsRoute);
    const accountSelected = computed(() => route.name === accountRoute);

    const state = reactive({
      listClasses: computed(() => listsSelected.value ? activeClasses : defaultClasses),
      accountClasses: computed(() => accountSelected.value ? activeClasses : defaultClasses)
    });

    const selectLists = () => router.push({ name: listsRoute });
    const selectAccounts = () => router.push({ name: accountRoute });

    return {
      selectLists,
      selectAccounts,
      state
    };
  }
};
</script>
