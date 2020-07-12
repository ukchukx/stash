<template>
  <!-- eslint-disable -->
  <Page :username="user.email">
    <EmptyList resource="movies" />
  </Page>
</template>
<script>
import Page from '@/components/Page';
import EmptyList from '@/components/EmptyList';

export default {
  name: 'Stash',
  components: {
    EmptyList,
    Page
  },
  props: {
    user: {
      type: Object,
      required: true
    },
    movies: {
      type: Array,
      required: true
    },
    books: {
      type: Array,
      required: true
    }
  }
};
</script>
