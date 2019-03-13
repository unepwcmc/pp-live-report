<template>
  <div>
    <div class="map--infographic" ref="map"></div>

    <chart-legend :rows="legend" :colours="legendColours"></chart-legend>
  </div>
</template>

<script>
  import Datamap from 'datamaps/dist/datamaps.world.js'
  import ChartLegend from '../charts/ChartLegend'

  export default {
    name: 'map-infographic',

    components: { ChartLegend },

    props: {
      countries: {
        type: Array,
        required: true
      },
      includeDeficiant: {
        type: Boolean,
        default: false
      },
      legend: Array,
    },

    data () {
      return {
        defaultFill: '#dedede',
        min: 0,
        max: 0,
        palette: ['#2179A7', '#53CCF7', '#9A014F', '#E9624D', '#F7BA02', '#86BF37', '#423781'],
        legendColours: [],
        dataset: {}
      }
    },

    mounted () {
      this.getMinMax()
      this.createDataset()
      this.createLegendColours()
      this.createMap()
    },

    methods: {
      createMap () {
        let map = new Datamap({
          element: this.$refs.map,
          fills: { defaultFill: this.defaultFill },
          data: this.dataset,
          projection: 'mercator',
          geographyConfig: {
            popupOnHover: false,
            highlightOnHover: false
          }
        })  
      },

      createDataset () {
        let countries = this.countries
        
        countries.sort((a, b) => {
          return a[1] - b[1]
        })

        let dataset = []

        countries.forEach(country => {
          let iso = country[0],
            value = country[1],
            colour = this.palette[value-1]

          dataset[iso] = { fillColor: colour }
        })

        this.dataset = dataset
      },

      createLegendColours () {
        let legendColours = []

        this.legend.forEach(item => {
          let colour = item.value == 'default' ? this.defaultFill : this.palette[item.value-1]

          legendColours.push(colour)
        })

        this.legendColours = legendColours
      },

      getMinMax () {
        const values = this.countries.map(country => { return country[1] })

        this.min = Math.min.apply(null, values)
        this.max = Math.max.apply(null, values)
      }
    }
  }
</script>
