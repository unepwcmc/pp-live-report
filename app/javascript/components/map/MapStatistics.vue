<template>
  <div class="map--statistics">
    <div :id="id" class="map__map"></div>

    <div class="map__panel">
      <div class="map__panel-top gutters">
        <h2 class="heading--map">{{ title }}</h2>
        <i
          :class="[isActive ? 'icon--close-white' : 'icon--chevron-down-white']"
          @click="togglePanel"
        ></i>
      </div>

      <div v-show="isActive">
        <p v-if="description" class="map__panel-description gutters">
          {{ description }}
        </p>
        <template v-if="tabs">
          <tabs 
            :id="`tabs-${id}`"
            :map-id="id"
          >
            <tab
              v-for="(tab, index) in tabsActive"
              :key="`tab-${index}`"
              :id="getTabId(index)"
              :title="tab.title"
            >
              <map-statistics-toggles
                :map-id="id"
                :parent-tab-id="getTabId(index)"
                :layers="tab.layers"
                :oecm-present="oecmPresent"
                :on-a-tab="true"
              ></map-statistics-toggles>
            </tab>
          </tabs>
        </template>
        <template v-else>
          <map-statistics-toggles
            :map-id="id"
            :layers="layersActive"
            :oecm-present="oecmPresent"
          ></map-statistics-toggles>
        </template>
      
        <hr class="tabs__splitter">
        
        <span class="map__oecm-toggle gutters" v-if="oecmPresent">
          Include OECMs (terrestrial and marine)
          <map-oecm-toggle 
            :map-id="id"
            v-on:toggled="handleOecmToggleChange"
            v-on:hide-layers="hideLayers"
            v-on:show-layers="showLayers"
          />
        </span>

        <hr class="tabs__splitter" v-if="oecmPresent">

        <div class="map__buttons flex flex-v-center gutters">
          <download
            text="CSV Download"
            title="Download reports in CSV format"
            :file-download="fileDownload"
            event-element="Download data link"
          ></download>
          <map-disclaimer :disclaimer="disclaimer"></map-disclaimer>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {
  RTL_TEXT_PLUGIN_URL,
  getMapboxLayerId,
  getLayerIdFromMapboxLayerId,
  getFirstTopLayerId,
} from "./map-helpers"
import Download from "../download/Download"
import MapDisclaimer from "./MapDisclaimer"
import MapOecmToggle from "./MapOECMToggle"
import MapStatisticsToggles from "./MapStatisticsToggles"
import Tab from "../tabs/Tab"
import Tabs from "../tabs/Tabs"

import { eventHub } from "../../packs/application.js"

const MAPBOX_STYLE = "mapbox://styles/unepwcmc/cko1hsfi50vog17l697cr4d6p"

export default {
  name: "map-statistics",

  components: { 
    Download, 
    MapDisclaimer, 
    MapOecmToggle,
    MapStatisticsToggles, 
    Tab, 
    Tabs 
  },

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
    oecmPresent: Boolean,
    tilesUrl: String,
    tilesUrlOecm: String,
    disclaimer: Object,
  },

  data() {
    return {
      activeTabId: '',
      includeOecms: false,
      map: {},
      mapLoaded: false,
      isActive: true,
      layersActive: [],
      layersDefault: [],
      layersOecm: [],
      mapboxToken: process.env.MAPBOX_TOKEN,
      tabsActive: [],
      tabsWithOecm: [],
      firstTopLayerId: "",
      haveSetRTLTextPlugin: false
    }
  },

  computed: {
    initialLayer() {
      return this.tabs ? this.tabs[0].layers[0] : this.layers[0]
    }
  },

  created () {
    if(this.tabs) {
      this.tabsActive = this.tabs
      this.activeTabId = this.getTabId(0)
      if(this.oecmPresent == true) { this.createTabsWithOecm() }
    } 

    this.getAllDefaultLayers()
    if(this.oecmPresent == true) { this.createLayersWithOecm() }
    this.layersActive = this.layersDefault
  },

  mounted() {
    eventHub.$on("change-tab", this.handleTabChange)
    eventHub.$on("hide-layers", this.hideLayers)
    eventHub.$on("show-layers", this.showLayers)
    
    this.createMap()
  },

  beforeDestroy() {
    eventHub.$off("change-tab")
    eventHub.$off("hide-layers")
    eventHub.$off("show-layers")
  },

  methods: {
    getTabId(index) {
      return `tab-${index}`
    },

    getLayerIdFromMapboxLayerId(mapboxLayerId) {
      return getLayerIdFromMapboxLayerId(mapboxLayerId)
    },

    getAllDefaultLayers() {
      if (this.tabs) {
        this.tabs.forEach((tab) => {
          this.layersDefault = this.layersDefault.concat(tab.layers)
        })
      } else {
        this.layersDefault = this.layersDefault.concat(this.layers)
      }
    },

    getLayerById(id) {
      let layer = null

      this.layersActive.forEach((l) => {
        if (l.id === id) {
          layer = l
        }
      })

      return layer
    },

    createMap() {
      mapboxgl.accessToken = this.mapboxToken

      this.map = new mapboxgl.Map({
        container: this.id,
        style: MAPBOX_STYLE,
        center: [0.0, -0.0],
        zoom: 1.3,
      })

      this.map.scrollZoom.disable()
      this.map.addControl(
        new mapboxgl.NavigationControl({ showCompass: false }),
        "top-left"
      )
      this.map.on("load", () => {
        this.mapLoaded = true
        this.firstTopLayerId = getFirstTopLayerId(this.map)
        this.addInitialLayers()
      })
    },

    addInitialLayers() {
      this.addLayerAndSubLayers(this.initialLayer)
    },

    addLayerAndSubLayers(layer) {
      this.addLayer(layer)

      if (layer.sublayers) {
        layer.sublayers.forEach((sublayer) => {
          this.addLayer(sublayer)
        })
      }
    },

    addLayer(layer) {
      const url = this.includeOecms == true ? this.tilesUrlOecm : this.tilesUrl

      if(layer.type == 'raster_tile') {
        this.addRasterTileLayer([url], layer)

      } else if (layer.source_layers && this.tilesUrl) {
        Object.keys(layer.source_layers).forEach((layerType) => {
          this.addMapboxLayer({
            tiles: [url],
            layerType,
            layer,
          })
        })
      }
    },

    addMapboxLayer({ tiles, layerType, layer }) {
      let id = getMapboxLayerId(layer, layerType),
        sourceLayer = layer.source_layers[layerType]

      const options = {
        id: id,
        source: {
          type: "vector",
          tiles: tiles,
        },
        "source-layer": sourceLayer,
        filter: layer.filter_id ? ["==", "_symbol", layer.filter_id] : ["all"],
      }

      if (layerType === "point") {
        options["type"] = "circle"
        options["paint"] = {
          "circle-radius": 2,
          "circle-color": layer.colour,
        }
      } else {
        options["type"] = "fill"
        options["paint"] = {
          "fill-color": layer.colour,
          "fill-outline-color": "transparent",
        }
      }

      this.map.addLayer(options, this.firstTopLayerId)
    },

    addRasterTileLayer (tiles, layer) {
      const options = {
        id: layer.id,
        type: 'raster',
        minzoom: 0,
        maxzoom: 22,
        source: {
          poly: layer.source_layers['poly'],
          type: 'raster',
          tiles: tiles,
          tileSize: 128,
        }
      }

      this.map.addLayer(options, this.firstTopLayerId)
    },

    createTabsWithOecm () {
      const tabsWithOecm = this.tabs.map(tab => {
        return {
          title: tab.title,
          layers: this.mapOecmProperties(tab.layers)
        }
      })

      this.tabsWithOecm = tabsWithOecm
    },

    createLayersWithOecm () {
      const oecmLayers = this.mapOecmProperties(this.layersDefault)
  
      this.layersOecm = oecmLayers
    },

    mapOecmProperties (layers) {
      return layers.map(layer => {
        return {
          id: layer.id + '_oecm',
          text_large: layer.text_large,
          source_layers: { poly: layer.source_layers.poly + '_oecm' },
          colour: layer.colour
        }
      })
    },

    handleTabChange (obj) {
      this.activeTabId = obj.tab
      this.handleOecmToggleChange({ mapId: obj.mapId, includeOecms: false })
      
    },

    handleOecmToggleChange (obj) {
      const params = { mapId: obj.mapId, activeTabId: this.activeTabId }
      
      eventHub.$emit('oecm-toggle-start', params)
      
      this.includeOecms = obj.includeOecms
      
      this.layersActive = this.includeOecms == true ? this.layersOecm : this.layersDefault
      
      if(this.tabs) { 
        this.tabsActive = obj.includeOecms == true ? this.tabsWithOecm : this.tabs
      }

      this.$nextTick(() => {
        eventHub.$emit('oecm-toggle-end', params)
      })
    },

    hideLayers(ids) {
      // If more than one map is present on the same page
      if (ids.mapId !== this.id) {
        return
      }

      this.hideVisibilityOfLayers(ids)
    },

    showLayers(ids) {
      if (ids.mapId !== this.id) {
        return
      }
      
      //address race condition with first layer trying to be added before map created
      this.waitUntilMapLoaded(this.setVisibilityOfLayers, ids, 100)
    },

    hideVisibilityOfLayers(ids) {
      ids.layerIds.forEach((mapboxLayerId) => {
        if (this.map.getLayer(mapboxLayerId)) {
          this.map.setLayoutProperty(mapboxLayerId, "visibility", "none")
        }
      })
    },

    setVisibilityOfLayers (ids) {
      ids.layerIds.forEach((mapboxLayerId) => {
        if (this.map.getLayer(mapboxLayerId)) {
          this.map.setLayoutProperty(mapboxLayerId, "visibility", "visible")
        } else {
          const baseLayer = this.getLayerById(
            this.getLayerIdFromMapboxLayerId(mapboxLayerId)
          )

          if (baseLayer) {
            this.addLayer(baseLayer)
          }
        }
      })
    },

    waitUntilMapLoaded(callback, params, delay) {
      let interval 

      if(this.mapLoaded === true) {
        callback(params)
        clearInterval(interval)
      } else { 
        interval = setInterval(() => {
          this.waitUntilMapLoaded(callback, params, delay)
        }, delay)
      }
    },

    togglePanel() {
      this.isActive = !this.isActive
    },
  },
};
</script>