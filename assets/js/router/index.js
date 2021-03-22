import { createWebHistory, createRouter } from 'vue-router';
import Account from '../components/Account.vue';
import Books from '../components/Books.vue';
import MovieLists from '../components/MovieLists.vue';
import List from '../components/List.vue';
import Signin from '../components/Signin.vue';
import Signup from '../components/Signup.vue';

const routes = [
  {
    path: '/movies',
    name: 'MovieLists',
    component: MovieLists
  },
  {
    path: '/books',
    name: 'BookLists',
    component: Books
  },
  {
    path: '/list',
    name: 'List',
    component: List
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
