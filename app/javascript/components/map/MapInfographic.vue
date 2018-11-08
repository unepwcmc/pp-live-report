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
      legend: Array
    },

    data () {
      return {
        defaultFill: '#dedede',
        groupTotal: 2,
        min: 0,
        max: 0,
        colourRange: ['#E3E1EC', '#423781'],
        paletteScale: '',
        legendColours: [],
        dataset: {},
        countries: [
          ["USA",30],["FRA",63], ["RUS",6]
        ]
      }
    },

    mounted () {
      this.getMinMax()
      this.createPaletteScale()
      this.createDataset()
      this.createMap()
    },

    methods: {
      createMap () {
        let map = new Datamap({
          element: this.$refs.map,
          fills: { defaultFill: this.defaultFill },
          data: this.dataset,
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

        let dataset = [],
          legendColours = [this.defaultFill]

        countries.forEach(country => {
          let iso = country[0],
            value = country[1],
            colour = this.paletteScale(value)

          dataset[iso] = { fillColor: colour }
          legendColours.push(colour)
        })

        this.dataset = dataset
        this.legendColours = legendColours
      },

      createPaletteScale () {
        this.paletteScale = d3.scale.linear()
          .domain([this.min, this.max])
          .range(this.colourRange)
      },

      getMinMax () {
        const values = this.countries.map(country => { return country[1] })

        this.min = Math.min.apply(null, values)
        this.max = Math.max.apply(null, values)
      }
    }
  }
</script>
