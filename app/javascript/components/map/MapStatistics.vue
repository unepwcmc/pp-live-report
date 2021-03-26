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
                :oecm-present="oecmPresent"
                :oecm-layer="oecmLayer"
              ></map-statistics-toggles>
            </tab>
          </tabs>
        </template>
        <template v-else>
          <map-statistics-toggles
            :map-id="id"
            :layers="activeLayers"
            :oecm-present="oecmPresent"
          ></map-statistics-toggles>
        </template>
      </template>
      <hr class="tabs__splitter">
      <span class="map__oecm-toggle gutters" v-if="oecmPresent">
        Include OECMs (terrestrial and marine)
        <map-oecm-toggle 
          :map-id="id"
          v-on:toggled="toggleOecmLayers"
          v-on:hide-layers="hideLayers"
          v-on:show-layers="showLayers"
        />
      </span>
      <hr class="tabs__splitter">
      <div class="map__buttons flex flex-v-center gutters" v-if="isActive">
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

const MAPBOX_STYLE = "mapbox://styles/unepwcmc/ckfy4y2nm0vqn19mkcmiyqo73"

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
    // oecmLayer: Object,
    oecmPresent: Boolean,
    tilesUrl: String,
    tilesUrlOecm: String,
    disclaimer: Object,
  },

  data() {
    return {
      activeTileLayer: '',
      activeLayers: [],
      includeOecms: false,
      oecmLayers: [],
      defaultLayers: [],
      oecmUrl: '',
      map: {},
      mapLoaded: false,
      isActive: true,
      mapboxToken: process.env.MAPBOX_TOKEN,
      allLayers: [],
      tabsWithOecm: [],
      firstTopLayerId: "",
    }
  },

  computed: {
    initialLayer() {
      return this.tabs ? this.tabs[0].layers[0] : this.layers[0]
    },
  },

  mounted() {
    eventHub.$on("hide-layers", this.hideLayers)
    eventHub.$on("show-layers", this.showLayers)
    
    this.getAllDefaultLayers()
    this.createMap()
    
    if(this.oecmPresent == true) { this.createOecmLayers() }

    this.activeLayers = this.defaultLayers
  },

  beforeDestroy() {
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
          this.defaultLayers = this.defaultLayers.concat(tab.layers)
        })
      } else {
        this.defaultLayers = this.defaultLayers.concat(this.layers)
      }

      // if(this.oecmPresent == true) { 
      //   this.allLayers = this.allLayers.concat(this.createOecmLayers())
      // }
    },

    getLayerById(id) {
      let layer = null

      this.activeLayers.forEach((l) => {
        if (l.id === id) {
          layer = l
        }
      })

      return layer
    },

    createMap() {
      mapboxgl.accessToken = this.mapboxToken

      // Add support for RTL languages
      // Make sure this is only called once per page
      if(mapboxgl.getRTLTextPluginStatus() == 'unavailable') {
        mapboxgl.setRTLTextPlugin(
          RTL_TEXT_PLUGIN_URL, 
          null, 
          true // Lazy loading
        )
      }

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
        console.log('loaded')
        this.mapLoaded = true
        this.firstTopLayerId = getFirstTopLayerId(this.map)
        this.addInitialLayers()
        // if(this.oecmPresent && typeof(this.oecmLayer) == 'object' && this.oecmLayer.hasOwnProperty('url')) {
        //   this.addLayer(this.oecmLayer)
        // }
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
      if(layer.type == 'raster_tile') {
        this.addRasterTileLayer(layer)

      } else if (layer.source_layers && this.tilesUrl) {
        
        // const url = this.oecmPresent == true && layer.tilesUrl != undefined ? layer.tilesUrl : this.tilesUrl

        const url = this.includeOecms == true ? this.tilesUrlOecm : this.tilesUrl
        console.log('url', url)

        
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
        
      // if(this.includeOecms == true) {
      //   id = `${id}_oecm`
      //   sourceLayer = `${sourceLayer}_oecm`
      // }

      // console.log('sourceLayer', sourceLayer)
      console.log('id', id)

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

    addRasterTileLayer (layer) {
      // const id = this.includeOecms == true ? `${layer.id}_oecm` : layer.id

      this.map.addLayer({
        id: id,
        type: 'raster',
        minzoom: 0,
        maxzoom: 22,
        source: {
          type: 'raster',
          tiles: [layer.url],
          tileSize: 128,
        },
        layout: {
          visibility: layer.isShownByDefault ? 'visible' : 'none'
        }
      }, this.firstTopLayerId)
    },

    createOecmLayers () {
      if(this.tabs) {
        const tabsWithOecm = this.tabs.map(tab => {
          return tab.layers.map(layer => {
            return {
              id: layer.id + '_oecm',
              text_large: layer.text_large,
              // tilesUrl: this.tilesUrlOecm,
              source_layers: { poly: layer.source_layers.poly + '_oecm' },
              colour: layer.colour
            }
          })
        })

        this.tabsWithOecm = tabsWithOecm

      } else {
        const oecmLayers = this.defaultLayers.map(layer => {
          return {
            id: layer.id + '_oecm',
            text_large: layer.text_large,
            // tilesUrl: this.tilesUrlOecm,
            source_layers: { poly: layer.source_layers.poly + '_oecm' },
            colour: layer.colour
          }
        })
    
        this.oecmLayers = oecmLayers
      }
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
        console.log('id 1', mapboxLayerId)
        
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
      setTimeout(() => {
        if(this.mapLoaded === true) {
          callback(params)
         } else { 
          this.waitUntilMapLoaded(callback, params, delay)
         }
      }, delay)
    },

    toggleOecmLayers (obj) {
      //check map
      //update layers to use oecm set
      eventHub.$emit('oecm-toggle-start', { mapId: obj.mapId})

      const useOecmLayers = obj.includeOecms

      this.activeLayers = useOecmLayers == true ? this.oecmLayers : this.defaultLayers
      this.includeOecms = obj.includeOecms


      this.$nextTick(() => {
        eventHub.$emit('oecm-toggle-end', { mapId: obj.mapId})
      })

      console.log('include oecms', obj.includeOecms)
      

      

      // then set previous active ones to active
      /* 
      a) 
      - hide all layers 
      - change activelayers to oecm
      - check the layers that were active before and make them active again
      -   
      */

    },
    
    togglePanel() {
      this.isActive = !this.isActive
    },
  },
};
</script>