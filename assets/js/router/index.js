import { createWebHistory, createRouter } from 'vue-router';
import Account from '../components/Account.vue';
import MovieLists from '../components/MovieLists.vue';
import Books from '../components/Books.vue';
import Movies from '../components/Movies.vue';
import Signin from '../components/Signin.vue';
import Signup from '../components/Signup.vue';

const routes = [
  {
    path: '/ml',
    name: 'MovieLists',
    component: MovieLists
  },
  {
    path: '/bl',
    name: 'BookLists',
    component: Books
  },
  {
    path: '/movies',
    name: 'Movies',
    component: Movies
  },
  {
    path: '/books',
    name: 'Books',
    component: Books
  },
  {
    path: '/m',
    name: 'Movie',
    component: Movies // TODO: Change
  },
  {
    path: '/b',
    name: 'Book',
    component: Books // TODO: Change
  },
  {
    path: '/account',
    name: 'Account',
    component: Account
  },
  {
    path: '/signin',
    name: 'Signin',
    component: Signin
  },
  {
    path: '/signup',
    name: 'Signup',
    component: Signup
  }
];

export default createRouter({ history: createWebHistory(), routes });
