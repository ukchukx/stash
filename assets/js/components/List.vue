<template>
  <!-- eslint-disable -->
  <div class="justify-between flex px-4 py-2 items-center border-b">
    <div class="text-gray-600 mr-3">
      <MovieIcon v-if="isMovie" />
      <BookIcon v-else />
    </div>
    <div class="flex w-full text-gray-600">
      <a :href="listHref">
        {{ list.name }}
      </a>
      <a href="javascript:;" @click="deleteList" class="ml-auto">
        <DeleteIcon />
      </a>
    </div>
  </div>
</template>
<script>
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';
import DeleteIcon from './DeleteIcon.vue';
import BookIcon from './BookIcon.vue';
import MovieIcon from './MovieIcon.vue';

export default {
  name: 'List',
  components: {
    BookIcon,
    DeleteIcon,
    MovieIcon
  },
  props: {
    list: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const router = useRouter();
    const store = useStore();
    const name = props.list.type === 'movie' ? 'Movies' : 'Books';
    const isMovie = name === 'Movies';
    const listHref = router.resolve({ name, query: { id: props.list.id } }).href;

    const deleteList = () => {
      if (!confirm('Sure?')) return;

      store.dispatch('deleteList', props.list.id);
    };

    return {
      listHref,
      deleteList,
      isMovie
    };
  }
};
</script>
