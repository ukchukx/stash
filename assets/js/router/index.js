import { createWebHistory, createRouter } from 'vue-router';
import Account from '../components/Account.vue';
import MovieLists from '../components/MovieLists.vue';
import BookLists from '../components/BookLists.vue';
import Books from '../components/Books.vue';
import Book from '../components/Book.vue';
import Movies from '../components/Movies.vue';
import Movie from '../components/Movie.vue';
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
    component: BookLists
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
