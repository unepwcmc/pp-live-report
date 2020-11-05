<template>
 <div class="map--statistics">
  <div :id="id" class="map__map"></div>

  <div class="map__panel">
   <div class="map__panel-top gutters">
    <h2 class="heading--map">{{ title }}</h2>
    <i
     :class="[isActive ? 'icon--close-white' : 'icon--minus-white']"
     @click="togglePanel"
    ></i>
   </div>

   <template v-if="isActive">
    <p v-if="description" class="map__panel-description gutters">
     {{ description }}
    </p>
    <template v-if="tabs">
     <tabs :id="`tabs-${id}`">
      <tab
       v-for="(tab, index) in tabs"
       :key="`tab-${index}`"
       :id="getTabId(index)"
       :title="tab.title"
      >
       <map-statistics-toggles
        :map-id="id"
        :parent-tab-id="getTabId(index)"
        :layers="tab.layers"
       ></map-statistics-toggles>
      </tab>
     </tabs>
    </template>
    <template v-else>
     <map-statistics-toggles
      :map-id="id"
      :layers="layers"
     ></map-statistics-toggles>
    </template>
   </template>
   <div class="flex flex-v-center gutters" v-if="isActive">
    <download
     text="CSV Download"
     title="Download reports in PDF format"
     :file-download="fileDownload"
     event-element="Download report link"
    ></download>
    <map-disclaimer :disclaimer="disclaimer"></map-disclaimer>
   </div>
  </div>
 </div>
</template>

<script>
import {
 getMapboxLayerId,
 getLayerIdFromMapboxLayerId,
 getFirstTopLayerId,
} from "./map-helpers";
import Download from "../download/Download";
import MapDisclaimer from "./MapDisclaimer";
import MapStatisticsToggles from "./MapStatisticsToggles";
import Tab from "../tabs/Tab";
import Tabs from "../tabs/Tabs";

import { eventHub } from "../../packs/application.js";

const MAPBOX_STYLE = "mapbox://styles/unepwcmc/ckfy4y2nm0vqn19mkcmiyqo73";

export default {
 name: "map-statistics",

 components: { Download, MapDisclaimer, MapStatisticsToggles, Tab, Tabs },

 props: {
  id: {
   type: String,
   required: true,
  },
  fileDownload: String,
  title: String,
  description: String,
  tabs: Array,
  layers: Array,
  tilesUrl: String,
  disclaimer: Object,
 },

 data() {
  return {
   map: {},
   isActive: true,
   mapboxToken: process.env.MAPBOX_TOKEN,
   allLayers: [],
   firstTopLayerId: "",
  };
 },

 computed: {
  initialLayer() {
   return this.tabs ? this.tabs[0].layers[0] : this.layers[0];
  },
 },

 mounted() {
   eventHub.$on("hide-layers", this.hideLayers);
   eventHub.$on("show-layers", this.showLayers);
  this.getAllLayers();
  this.createMap();
 },

 methods: {
  getTabId(index) {
   return `tab-${index}`;
  },

  getLayerIdFromMapboxLayerId(mapboxLayerId) {
   return getLayerIdFromMapboxLayerId(mapboxLayerId);
  },

  getAllLayers() {
   if (this.tabs) {
    this.tabs.forEach((tab) => {
     this.allLayers = this.allLayers.concat(tab.layers);
    });
   } else {
    this.allLayers = this.allLayers.concat(this.layers);
   }
  },

  getLayerById(id) {
   let layer = null;

   this.allLayers.forEach((l) => {
    if (l.id === id) {
     layer = l;
    }
   });

   return layer;
  },

  createMap() {
   mapboxgl.accessToken = this.mapboxToken;

   this.map = new mapboxgl.Map({
    container: this.id,
    style: MAPBOX_STYLE,
    center: [0.0, -0.0],
    zoom: 1.3,
   });

   this.map.scrollZoom.disable();
   this.map.addControl(
    new mapboxgl.NavigationControl({ showCompass: false }),
    "top-left"
   );
   this.map.on("load", () => {
    this.firstTopLayerId = getFirstTopLayerId(this.map);
    this.addInitialLayers();
   });
  },

  addInitialLayers() {
    this.addLayerAndSubLayers(this.initialLayer);
  },

  addLayerAndSubLayers(layer) {
   this.addLayer(layer);

   if (layer.sublayers) {
    layer.sublayers.forEach((sublayer) => {
     this.addLayer(sublayer);
    });
   }
  },

  addLayer(layer) {
   if (layer.source_layers && this.tilesUrl) {
    Object.keys(layer.source_layers).forEach((layerType) => {
     this.addMapboxLayer({
      tiles: [this.tilesUrl],
      layerType,
      layer,
     });
    });
   }
  },

  addMapboxLayer({ tiles, layerType, layer }) {
   const options = {
    id: getMapboxLayerId(layer, layerType),
    source: {
     type: "vector",
     tiles: tiles,
    },
    "source-layer": layer.source_layers[layerType],
    filter: layer.filter_id ? ["==", "_symbol", layer.filter_id] : ["all"],
   };

   if (layerType === "point") {
    options["type"] = "circle";
    options["paint"] = {
     "circle-radius": 2,
     "circle-color": layer.colour,
    };
   } else {
    options["type"] = "fill";
    options["paint"] = {
     "fill-color": layer.colour,
     "fill-outline-color": "transparent",
    };
   }

   this.map.addLayer(options, this.firstTopLayerId);
  },

  hideLayers(ids) {
   this.hideVisibilityOfLayers(ids);
  },

  showLayers(ids) {
   this.setVisibilityOfLayers(ids);
  },

  hideVisibilityOfLayers(ids) {
   // If more than one map is present on the same page
   if (ids.mapId !== this.id) {
    return;
   }

   ids.layerIds.forEach((mapboxLayerId) => {
    if (this.map.getLayer(mapboxLayerId)) {
     this.map.setLayoutProperty(mapboxLayerId, "visibility", "none");
    }
   });
  },

  setVisibilityOfLayers(ids) {
   if (ids.mapId !== this.id) {
    return;
   }

   ids.layerIds.forEach((mapboxLayerId) => {
    if (this.map.getLayer(mapboxLayerId)) {
     this.map.setLayoutProperty(mapboxLayerId, "visibility", "visible");
    } else {
     const baseLayer = this.getLayerById(
      this.getLayerIdFromMapboxLayerId(mapboxLayerId)
     );

     if (baseLayer) {
      this.addLayer(baseLayer);
     }
    }
   });
  },
  togglePanel() {
   this.isActive = !this.isActive;
  },
 },
};
</script>