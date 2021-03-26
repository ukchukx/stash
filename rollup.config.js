import alias from '@rollup/plugin-alias';
import commonjs from '@rollup/plugin-commonjs';
import replace from '@rollup/plugin-replace';
import VuePlugin from 'rollup-plugin-vue';
import resolve from '@rollup/plugin-node-resolve';
import { terser } from 'rollup-plugin-terser';
import postcss from 'rollup-plugin-postcss';
import json from '@rollup/plugin-json';

const isProduction = process.env.NODE_ENV === 'production';
const replacementValue = isProduction ? 'production' : 'development';

export default {
  input: 'assets/js/app.js',
  output: {
    file: 'priv/static/app.js',
    sourcemap: true,
    format: 'iife'
  },
  plugins: [
    replace({
      'process.env.NODE_ENV': JSON.stringify(replacementValue),
      '__VUE_OPTIONS_API__': false,
      '__VUE_PROD_DEVTOOLS__': false
    }),
    json(),
    VuePlugin(),
    resolve({ browser: true }), // tells Rollup how to find libraries in node_modules
    commonjs(), // converts libraries to ES modules
    postcss({
      plugins: [
        require('postcss-import')(),
        require('postcss-url')(),
        require('tailwindcss')('assets/tailwind.config.js'),
        require('autoprefixer')()
      ],
      extract: 'app.css'
    }),
    alias({
      vue: require.resolve('vue/dist/vue.runtime.esm-bundler.js')
    }),
    isProduction && terser() // minify
  ],
  watch: {
    include: 'assets/js/**',
    exclude: 'node_modules/**'
  }
}