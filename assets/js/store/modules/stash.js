import axios from 'axios';

const commonRequestOptions = () => ({
  withCredentials: true,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json;charset=UTF-8',
  }
});

const state = {
  movies: [],
  books: [],
  lists: []
};

// getters
const getters = {
  movieLists: ({ lists }) => lists.filter(({ type }) => type === 'movie'),
  bookLists: ({ lists }) => lists.filter(({ type }) => type === 'book'),
  movies: ({ movies }) => movies,
  books: ({ books }) => books,
  list: ({ lists }) => (id) => lists.find((list) => list.id === id),
  moviesForList: ({ movies }) => (id) => movies.filter(({ list_id }) => list_id === id),
  booksForList: ({ books }) => (id) => books.filter(({ list_id }) => list_id === id)
}

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
    return axios.post('/api/lists', data, { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('add', { key: 'lists', data });
        return data;
      });
  },
  deleteList ({ commit }, id) {
    return axios.delete(`/api/lists/${id}`, { ...commonRequestOptions() })
      .then(() => {
        commit('removeList', id);
        return true;
      });
  },
  fetchMovies ({ commit }, id) {
    return axios.get(`/api/movies/${id}`, { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('set', { key: 'movies', data });
        return data;
      });
  },
  createMovie ({ commit }, data) {
    return axios.post('/api/movies', data, { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('add', { key: 'movies', data });
        return data;
      });
  },
  deleteMovie ({ commit }, id) {
    return axios.delete(`/api/movies/${id}`, { ...commonRequestOptions() })
      .then(() => {
        commit('remove', { key: 'movies', id });
        return true;
      });
  },
  fetchBooks ({ commit }, id) {
    return axios.get(`/api/books/${id}`, { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('set', { key: 'books', data });
        return data;
      });
  },
  createBook ({ commit }, data) {
    return axios.post('/api/books', data, { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('add', { key: 'books', data });
        return data;
      });
  },
  deleteBook ({ commit }, id) {
    return axios.delete(`/api/books/${id}`, { ...commonRequestOptions() })
      .then(() => {
        commit('remove', { key: 'books', id });
        return true;
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
      state[key][index] = data;
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
