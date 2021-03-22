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
  moviesForList: ({ movies }) => (id) => movies.filter(({ list_id }) => list_id === id),
  booksForList: ({ books }) => (id) => books.filter(({ list_id }) => list_id === id)
}

// actions
const actions = {
  fetchLists ({ commit }) {
    return axios.get('/api/lists',  { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('set', { key: 'lists', data });
        return data;
      });
  },
  createList ({ commit }, data) {
    return axios.post('/api/lists', data,  { ...commonRequestOptions() })
      .then(({ data: { data } }) => {
        commit('add', { key: 'lists', data });
        return data;
      });
  },
  deleteList ({ commit }, listId) {
    return axios.delete(`/api/lists/${listId}`,  { ...commonRequestOptions() })
      .then(() => {
        commit('removeList', listId);
        return true;
      });
  }
}

const remove = (state, { key, id }) => {
  const index = state[key].findIndex((item) => id === item.id);
  if (index) {
    state[key].splice(index, 1);
  }
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
