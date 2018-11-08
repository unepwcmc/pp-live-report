<template>
  <div class="map--statistics">
    <div id="map" class="map__map"></div>  

    <div class="map__panel gutters">
      <h2 class="heading--map">{{ title }}</h2>

      <div v-for="layer in layers" class="map__panel-layer">
        <div class="flex flex-v-center">
          <p class="map__panel-layer-stat no-margin flex flex-v-center flex-h-end">
            <span class="map__panel-layer-button"></span>  
            <span class="map__panel-layer-percentage">{{ layer.percentage }}%</span>
          </p>
          <p class="map__panel-layer-title no-margin">{{ layer.title }}</p>
        </div>

        <template v-if="layer.sublayers">
          <div v-for="sublayer in layer.sublayers" class="flex flex-v-center map__panel-sublayer">
            <p class="map__panel-layer-stat no-margin flex flex-v-center flex-h-end">
              <span class="map__panel-sublayer-button"></span>  
              <span class="map__panel-sublayer-percentage">{{ sublayer.percentage }}%</span>
            </p>
            <p class="map__panel-layer-title no-margin">{{ sublayer.title }}</p>
          </div>
        </template>
      </div>

      <span class="map__source">{{ source }}</span>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'map-statistics',

    props: {
      title: String,
      layers: {
        type: Array,
        required: true
      },
      source: String
    },

    data () {
      return {
        mapbox: {
          accessToken: process.env.MAPBOX_TOKEN,
          // baseUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places'
        },
      }
    },

    mounted () {
      this.createMap()
    },

    methods: {
      createMap () {
        mapboxgl.accessToken = this.mapbox.accessToken

        let map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/mapbox/streets-v9'
        })
      }
    }
  }
</script>