// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

// store
import store from '../store/store.js'

// vue components

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

// create vue instance and attach to the DOM
// document.addEventListener('DOMContentLoaded', () => {
document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#v-app',
    store,
    components: {}
  })
})
