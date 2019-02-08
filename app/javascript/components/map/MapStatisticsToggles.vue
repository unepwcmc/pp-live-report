<template>
  <div>
    <div v-for="layer in layers" class="map__panel-layer">
      <map-statistics-toggle :ids="getIds(layer)">
        <p class="map__panel-layer-button">
          <span class="map__panel-layer-button-inner" :style="{ 'background-color': layer.colour }"></span>
        </p>    
        <span class="map__panel-layer-text-large">{{ layer.text_large }}</span>
        <span>{{ layer.text_small }}</span>
      </map-statistics-toggle>

      <template v-if="layer.sublayers">
        <map-statistics-toggle v-for="sublayer in layer.sublayers" :ids="getIds(sublayer)" class="map__panel-sublayer">
          <p class="map__panel-sublayer-button">
            <span class="map__panel-sublayer-button-inner" :style="{ 'background-color': sublayer.colour }"></span>
          </p>
          <span class="map__panel-sublayer-text-large">{{ sublayer.text_large }}</span>
          <span>{{ sublayer.text_small }}</span>
        </map-statistics-toggle>
      </template>
    </div>
  </div>
</template>

<script>
  import MapStatisticsToggle from './MapStatisticsToggle'

  export default {
    name: 'map-statistics-toggles',

    components: { MapStatisticsToggle },

    props: {
      layers: {
        type: Array,
        required: true
      }
    },

    methods: {
      getIds (layer) {
        let ids = []

        if(layer.sql) {
          ids.push(layer.id + '-polys')
          ids.push(layer.id + '-points')
        } else {
          ids.push(layer.id)
        }

        return ids
      }
    }
  }
</script>