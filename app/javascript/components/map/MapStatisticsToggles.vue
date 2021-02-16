<template>
 <div class="map__panel-gradient gutters">
  <span class="map__oecm-toggle" v-if="oecmPresent">
    Include OECM contribution
    <map-oecm-toggle 
      :layer="oecmLayer"
      :map-id="mapId"
    />
  </span>
  <ul class="map__panel-layers">
   <li
    v-for="(layer, index) in layers"
    :key="`layer-${index}`"
    class="map__panel-layer"
   >
    <map-statistics-toggle
     :map-id="mapId"
     :parent-tab-id="parentTabId"
     :ids="getMapboxLayerIds(layer)"
     :is-active="index === currentLayer"
     :layer-no="index"
    >
     <div class="map__panel-button-wrapper">
      <p class="map__panel-layer-button">
       <span class="map__panel-layer-button-inner"></span>
      </p>
     </div>
     <span v-if="layer.text_small" class="map__panel-layer-text">{{
      layer.text_small
     }}</span>
     <span v-else class="map__panel-layer-text">{{ layer.text_large }}</span>
    </map-statistics-toggle>
   </li>
  </ul>
 </div>
</template>

<script>
import { eventHub } from "../../packs/application.js"
import { getMapboxLayerIds } from "./map-helpers"
import MapOecmToggle from "./MapOECMToggle"
import MapStatisticsToggle from "./MapStatisticsToggle"

export default {
 name: "map-statistics-toggles",

 components: { MapOecmToggle, MapStatisticsToggle },

 props: {
  layers: {
   type: Array,
   required: true,
  },
  oecmPresent: Boolean,
  oecmLayer: Object,
  parentTabId: String,
  mapId: String,
 },
 data() {
   return {
     currentLayer: 0
   }
 },
 mounted () {
  eventHub.$on("hide-other-layers", this.hideNonSelectedLayers)
  eventHub.$on("change-tab", this.handleTabChange)
 },
 methods: {
  getMapboxLayerIds(layer) {
   return getMapboxLayerIds(layer)
  },
  hideNonSelectedLayers(obj) {
    if (obj.mapId !== this.mapId || this.parentTabId !== obj.tab) { return }
    this.currentLayer = obj.layerNo
  },
  handleTabChange(obj) {
    if (this.parentTabId === obj.tab) { return }
    this.currentLayer = 0 
  }
 },
}
</script>