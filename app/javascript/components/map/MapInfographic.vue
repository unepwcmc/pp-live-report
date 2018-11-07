<template>
  <div>
    <div class="map--infographic" ref="map"></div>
  </div>
</template>

<script>
  import Datamap from 'datamaps/dist/datamaps.world.js'

  export default {
    name: 'map-infographic',

    data () {
      return {
        groupTotal: 5,
        min: 0,
        max: 0,
        colourRange: ['#423781', '#E3E1EC'],
        paletteScale: '',
        dataset: {},
        countries: [
          ['USA', 10], ['FRA', 34], ['COL', 45], ['RUS', 79], ['CHN', 89], 
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
          fills: { defaultFill: '#dedede' },
          data: this.dataset
        })  
      },

      createDataset () {
        let dataset = []

        this.countries.forEach(country => {
          let iso = country[0],
            value = country[1]

          dataset[iso] = { fillColor: this.paletteScale(value) }
        })

        this.dataset = dataset
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
