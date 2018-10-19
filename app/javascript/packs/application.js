// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

// store
import store from '../store/store.js'

// vue components
import Accordion from '../components/accordion/Accordion'
import AccordionItem from '../components/accordion/AccordionItem'
import CarouselFixed from '../components/carousel/CarouselFixed'
import ChartRow from '../components/charts/ChartRow'
import NavBurger from '../components/nav/NavBurger'
import NavLink from '../components/nav/NavLink'
import SocialShare from '../components/social/SocialShare'

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

// create vue instance and attach to the DOM
// document.addEventListener('DOMContentLoaded', () => {
document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#v-app',
    store,
    components: {
      Accordion,
      AccordionItem,
      CarouselFixed,
      ChartRow,
      NavBurger,
      NavLink,
      SocialShare
    }
  })
})
