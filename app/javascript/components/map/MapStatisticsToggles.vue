<template>
  <div>
    <ul class="map__panel-layers gutters">
      <li v-for="(layer, index) in layers" :key="`layer-${index}`" class="map__panel-layer">
        <map-statistics-toggle :map-id="mapId" :parent-tab-id="parentTabId" :ids="getMapboxLayerIds(layer)">
          <div class="map__panel-button-wrapper">
            <p class="map__panel-layer-button">
              <span class="map__panel-layer-button-inner"></span>
            </p>
          </div>
          <span v-if="layer.text_small" class="map__panel-layer-text">{{ layer.text_small }}</span>
          <span v-else class="map__panel-layer-text">{{ layer.text_large }}</span>
        </map-statistics-toggle>

<!-- Move sublayers into a separate component below row of layer buttons  -->
        <template v-if="layer.sublayers">
        <ul class="">
          <li v-for="(sublayer, index) in layer.sublayers" :key="`sublayer-${index}`" class="map__panel-sublayer">
            <map-statistics-toggle  :map-id="mapId" :parent-tab-id="parentTabId" :ids="getMapboxLayerIds(sublayer)" >
              <div class="map__panel-button-wrapper">
                <p class="map__panel-sublayer-button">
                  <span class="map__panel-sublayer-button-inner" :style="{ 'background-color': sublayer.colour }"></span>
                </p>
              </div>
              <span v-if="sublayer.text_large" class="map__panel-sublayer-text-large">{{ sublayer.text_large }}</span>
              <span v-if="sublayer.text_small" class="map__panel-layer-text">{{ sublayer.text_small }}</span>
            </map-statistics-toggle>
          </li>
        </ul>
      </template>
      </li>
    </ul>
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