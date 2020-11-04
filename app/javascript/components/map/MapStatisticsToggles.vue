<template>
 <div>
  <span class="map__oecm-toggle gutters"
   >Include OECM contribution<map-oecm-toggle @oecm-toggle="toggleOECM"></map-oecm-toggle
  ></span>
  <ul class="map__panel-layers gutters">
   <li
    v-for="(layer, index) in layers"
    :key="`layer-${index}`"
    class="map__panel-layer"
   >
    <map-statistics-toggle
     :map-id="mapId"
     :parent-tab-id="parentTabId"
     :ids="getMapboxLayerIds(layer)"
     :is-active="index === 0"
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
import { getMapboxLayerIds } from "./map-helpers";
import MapOecmToggle from "./MapOECMToggle";
import MapStatisticsToggle from "./MapStatisticsToggle";

export default {
 name: "map-statistics-toggles",

 components: { MapOecmToggle, MapStatisticsToggle },

 props: {
  layers: {
   type: Array,
   required: true,
  },
  parentTabId: String,
  mapId: String,
 },

 methods: {
  getMapboxLayerIds(layer) {
   return getMapboxLayerIds(layer);
  },
  toggleOECM(boolean) {
    // console.log('hello');
  }
 },
};
</script>