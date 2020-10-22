import { polyfill } from 'es6-promise'
polyfill()

import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'
import createPersistedState from "vuex-persistedstate";
Vue.use(Vuex)

import { multilingual } from './_multilingual.js';

export default new Vuex.Store({
  modules: {
    multilingual
  },
  plugins: [
    // createPersistedState({

    // })
  ]
})
