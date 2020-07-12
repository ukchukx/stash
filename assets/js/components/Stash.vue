<template>
  <h3>User is {{ user.email }}</h3>
</template>
<script>
export default {
  name: 'Stash',
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
