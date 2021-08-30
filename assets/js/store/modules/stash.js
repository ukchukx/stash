import axios from 'axios';

const token = document.head.querySelector('meta[name="csrf-token"]');

const commonRequestOptions = () => ({
  withCredentials: true,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json;charset=UTF-8',
    'X-CSRF-TOKEN': token ? token.content : ''
  }
});

const state = {
  movies: [],
  books: [],
  lists: []
};

// getters
const getters = {
  lists: ({ lists }) => lists,
  movies: ({ movies }) => movies,
  books: ({ books }) => books,
  list: ({ lists }) => (id) => lists.find((list) => list.id === id),
  book: ({ books }) => (id) => books.find((book) => book.id === id),
  movie: ({ movies }) => (id) => movies.find((movie) => movie.id === id),
  moviesForList: ({ movies }) => (id) => movies.filter(({ list_id }) => list_id === id),
  booksForList: ({ books }) => (id) => books.filter(({ list_id }) => list_id === id)
}

const deleteResource = (resource, id) => axios.delete(`/api/${resource}/${id}`, { ...commonRequestOptions() });
const getResourceByList = (resource, id) => axios.get(`/api/${resource}/${id}`, { ...commonRequestOptions() });
const createResource = (resource, data) => axios.post(`/api/${resource}`, data, { ...commonRequestOptions() });
const updateResource = (resource, data) => axios.put(`/api/${resource}/${data.id}`, data, { ...commonRequestOptions() });

// actions
const actions = {
  fetchLists ({ commit }) {
    return axios.get('/api/lists', { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('set', { key: 'lists', data });
        return data;
      });
  },
  createList ({ commit }, data) {
    return createResource('lists', data)
      .then(({ data: { data } }) => {
        commit('add', { key: 'lists', data });
        return data;
      });
  },
  deleteList ({ commit }, id) {
    return deleteResource('lists', id)
      .then(() => {
        commit('removeList', id);
        return true;
      });
  },
  fetchMovies ({ commit }, id) {
    return getResourceByList('movies', id)
      .then(({ data: { data } }) => {
        commit('set', { key: 'movies', data });
        return data;
      });
  },
  createMovie ({ commit }, data) {
    return createResource('movies', data)
      .then(({ data: { data } }) => {
        commit('add', { key: 'movies', data });
        return data;
      });
  },
  deleteMovie ({ commit }, id) {
    return deleteResource('movies', id)
      .then(() => {
        commit('remove', { key: 'movies', id });
        return true;
      });
  },
  updateMovie ({ commit }, data) {
    return updateResource('movies', data)
      .then(({ data: { data } }) => {
        commit('add', { key: 'movies', data });
        return data;
      });
  },
  fetchBooks ({ commit }, id) {
    return getResourceByList('books', id)
      .then(({ data: { data } }) => {
        commit('set', { key: 'books', data });
        return data;
      });
  },
  createBook ({ commit }, data) {
    return createResource('books', data)
      .then(({ data: { data } }) => {
        commit('add', { key: 'books', data });
        return data;
      });
  },
  deleteBook ({ commit }, id) {
    return deleteResource('books', id)
      .then(() => {
        commit('remove', { key: 'books', id });
        return true;
      });
  },
  updateBook ({ commit }, data) {
    return updateResource('books', data)
      .then(({ data: { data } }) => {
        commit('add', { key: 'books', data });
        return data;
      });
  }
}

const remove = (state, { key, id }) => {
  state[key] = state[key].filter((item) => id !== item.id);
}

// mutations
const mutations = {
  set(state, { key, data }) {
    state[key] = data;
  },
  add(state, { key, data }) {
    const index = state[key].findIndex(({ id }) => id === data.id);
    if (index) {
      state[key].splice(index, 1, data);
    } else {
      state[key].push(data);
    }
  },
  remove,
  removeList(state, id) {
    state.books = state.books.filter(({ list_id }) => list_id !== id);
    state.movies = state.movies.filter(({ list_id }) => list_id !== id);
    remove(state, { key: 'lists', id });
  }
}

export default {
  state,
  getters,
  actions,
  mutations
};
