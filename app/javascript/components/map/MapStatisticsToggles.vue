<template>
  <div>
    <div v-for="layer in layers" class="map__panel-layer">
      <map-statistics-toggle :map-id="mapId" :parent-tab-id="parentTabId" :ids="getMapboxLayerIds(layer)">
        <p class="map__panel-layer-button">
          <span class="map__panel-layer-button-inner" :style="{ 'background-color': layer.colour }"></span>
        </p>    
        <span v-if="layer.text_large" class="map__panel-layer-text-large">{{ layer.text_large }}</span>
        <span>{{ layer.text_small }}</span>
      </map-statistics-toggle>

      <template v-if="layer.sublayers">
        <map-statistics-toggle v-for="sublayer in layer.sublayers" :map-id="mapId" :parent-tab-id="parentTabId" :ids="getMapboxLayerIds(sublayer)" class="map__panel-sublayer">
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
  import { getMapboxLayerIds } from './map-helpers'
  import MapStatisticsToggle from './MapStatisticsToggle'

  export default {
    name: 'map-statistics-toggles',

    components: { MapStatisticsToggle },

    props: {
      layers: {
        type: Array,
        required: true
      },
      parentTabId: String,
      mapId: String
    },

    methods: {
      getMapboxLayerIds (layer) {
        return getMapboxLayerIds(layer)
      }
    }
  }
</script>