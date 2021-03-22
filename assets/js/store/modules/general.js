const dataset = document.getElementById('app').dataset;

const state = {
  tmdbToken: dataset.tmdbToken,
  user: (dataset.user && JSON.parse(dataset.user)) || {}
};

// getters
const getters = {
  tmdbToken: ({ tmdbToken }) => tmdbToken,
  user: ({ user }) => user
};

// actions
const actions = {};

// mutations
const mutations = {};

export default {
  state,
  getters,
  actions,
  mutations
};
