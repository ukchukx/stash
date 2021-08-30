import { createWebHistory, createRouter } from 'vue-router';
import Account from '../components/Account.vue';
import Books from '../components/Books.vue';
import Book from '../components/Book.vue';
import Lists from '../components/Lists.vue';
import Movies from '../components/Movies.vue';
import Movie from '../components/Movie.vue';
import Signin from '../components/Signin.vue';
import Signup from '../components/Signup.vue';

const routes = [
  {
    path: '/lists',
    name: 'Lists',
    component: Lists
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
    component: Movie
  },
  {
    path: '/b',
    name: 'Book',
    component: Book
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
