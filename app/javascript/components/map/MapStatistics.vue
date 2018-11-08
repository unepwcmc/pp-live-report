<template>
  <div class="map--statistics">
    <div id="map" class="map__map"></div>  

    <div class="map__panel gutters">
      <h2 class="heading--map">{{ title }}</h2>

      <div v-for="layer in layers" class="map__panel-layer">
        <p class="flex no-margin">
          <span class="map__panel-layer-percentage">{{ layer.percentage }}%</span>
          <span class="map__panel-layer-title">{{ layer.title }}</span>
        </p>

        <template v-if="layer.sublayers">
          <p v-for="sublayer in layer.sublayers" class="flex no-margin map__panel-sublayer">
            <span class="map__panel-sublayer-percentage">{{ sublayer.percentage }}%</span>
            <span class="map__panel-layer-title">{{ sublayer.title }}</span>
          </p>
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

    methods: {
      createMap () {
        mapboxgl.accessToken = 'undefined'

        let map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/mapbox/streets-v9'
        })
      }
    }
  }
</script>