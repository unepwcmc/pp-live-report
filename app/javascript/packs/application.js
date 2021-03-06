// polyfills
import 'babel-polyfill'

// libraries
import Vue from 'vue/dist/vue.esm'
import VueAnalytics from 'vue-analytics'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

if (window._railsEnv === 'production') {
  Vue.use(VueAnalytics, {
    id: 'UA-129227134-1',
    checkDuplicatedScript: true
  })
}
Vue.use(TurbolinksAdapter)

// store
import store from '../store/store.js'

// vue components
import Accordion from '../components/accordion/Accordion'
import AccordionItem from '../components/accordion/AccordionItem'
import CarouselFixed from '../components/carousel/CarouselFixed'
import ChartArea from '../components/charts/ChartArea'
import ChartColumn from '../components/charts/ChartColumn'
import ChartDoughnut from '../components/charts/ChartDoughnut'
import ChartLine from '../components/charts/ChartLine'
import ChartLegend from '../components/charts/ChartLegend'
import ChartRow from '../components/charts/ChartRow'
import ChartRowStacked from '../components/charts/ChartRowStacked'
import Download from '../components/download/Download'
import MapInfographic from '../components/map/MapInfographic'
import MapStatistics from '../components/map/MapStatistics'
import NavBurger from '../components/nav/NavBurger'
import NavLink from '../components/nav/NavLink'
import SocialShare from '../components/social/SocialShare'

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

// create vue instance and attach to the DOM
document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#v-app',
    store,
    components: {
      Accordion,
      AccordionItem,
      CarouselFixed,
      ChartArea,
      ChartColumn,
      ChartDoughnut,
      ChartLegend,
      ChartLine,
      ChartRow,
      ChartRowStacked,
      Download,
      MapInfographic,
      MapStatistics,
      NavBurger,
      NavLink,
      SocialShare
    }
  })
})
