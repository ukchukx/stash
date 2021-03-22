import { createStore, createLogger } from 'vuex';
import createPersistedState from 'vuex-persistedstate';
import general from './modules/general';
import stash from './modules/stash';

const debug = process.env.NODE_ENV !== 'production';
const persistedState = createPersistedState({ key: 'stash' });

export default createStore({
  modules: {
    general,
    stash
  },
  strict: debug,
  plugins: debug ? [createLogger(), persistedState] : [persistedState]
});
