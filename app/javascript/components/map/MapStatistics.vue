<template>
  <div class="map--statistics">
    <div :id="id" class="map__map"></div>

    <div class="map__panel gutters">
      <h2 class="heading--map">{{ title }}</h2>
      <p v-if="description" class="map__panel-description">{{ description }}</p>
      
      <template v-if="tabs">
        <tabs :id="`tabs-${id}`">
          <tab v-for="tab, index in tabs" :id="getTabId(index)" :title="tab.title">
            <map-statistics-toggles :map-id="id" :parent-tab-id="getTabId(index)" :layers="tab.layers"></map-statistics-toggles>
          </tab>
        </tabs>
      </template>

      <template v-else>
        <map-statistics-toggles :map-id="id" :layers="layers"></map-statistics-toggles>
      </template>

      <span class="map__source">{{ source }}</span>
    </div>
  </div>
</template>

<script>
import { getMapboxLayerId, getLayerIdFromMapboxLayerId, getFirstTopLayerId } from './map-helpers'
import MapStatisticsToggles from './MapStatisticsToggles'
import Tab from '../tabs/Tab'
import Tabs from '../tabs/Tabs'

import { eventHub } from "../../packs/application.js";

export default {
  name: 'map-statistics',

  components: { MapStatisticsToggles, Tab, Tabs },

  props: {
    id: {
      type: String,
      required: true
    },
    title: String,
    description: String,
    tabs: Array,
    layers: Array,
    tilesUrl: String,
    source: String
  },

  data () {
    return {
      map: {},
      mapboxToken: process.env.MAPBOX_TOKEN,
      allLayers: [],
      firstTopLayerId: ''
    }
  },

  computed: {
    initialLayers () {
      return this.tabs ? this.tabs[0].layers : this.allLayers
    }
  },

  mounted () {
    eventHub.$on('hideLayers', this.hideLayers)
    eventHub.$on('showLayers', this.showLayers)
    this.getAllLayers()
    this.createMap()
  },

  methods: {
    getTabId (index) {
      return `tab-${index}`
    },

    getLayerIdFromMapboxLayerId (mapboxLayerId) {
      return getLayerIdFromMapboxLayerId(mapboxLayerId)
    },

    getAllLayers () {
      if(this.tabs) {
        this.tabs.forEach(tab => {
          this.allLayers = this.allLayers.concat(tab.layers)
        })
      } else {
        this.allLayers = this.allLayers.concat(this.layers)
      }
    },

    getLayerById (id) {
      let layer = null

      this.allLayers.forEach(l => {
        if (l.id === id) { layer = l }
      })

      return layer
    },

    createMap () {
      mapboxgl.accessToken = this.mapboxToken

      this.map = new mapboxgl.Map({
        container: this.id,
        style: 'mapbox://styles/unepwcmc/cjo95gdrg0qzh2roan77pelcj',
        center: [0.000000, -0.000000],
        zoom: 1.3
      })

      this.map.scrollZoom.disable()
      this.map.addControl(new mapboxgl.NavigationControl({ showCompass: false }), 'top-left')
      this.map.on("load", () => { 
        this.firstTopLayerId = getFirstTopLayerId(this.map)
        this.addInitialLayers() 
      })
    },

    addInitialLayers () {
      if (this.initialLayers.length) {
        this.initialLayers.forEach(layer => { 
          this.addLayerAndSubLayers(layer) 
        })
      }
    },

    addLayerAndSubLayers (layer) {
      this.addLayer(layer)

      if(layer.sublayers) {
        layer.sublayers.forEach(sublayer => {
          this.addLayer(sublayer)
        })
      }
    },

    addLayer (layer) {  
      if (layer.source_layers && this.tilesUrl) {
        Object.keys(layer.source_layers).forEach(layerType => {
          this.addMapboxLayer({
            tiles: [this.tilesUrl],
            layerType,
            layer
          })
        })
      }
    },

    addMapboxLayer ({tiles, layerType, layer}) {
      const options = {
        'id': getMapboxLayerId(layer, layerType),
        'source': {
          'type': 'vector',
          'tiles': tiles
        },
        'source-layer': layer.source_layers[layerType],
        'filter': layer.filter_id ? ['==', '_symbol', layer.filter_id] : ['all']
      }

      if (layerType === 'point') {
        options['type'] = 'circle'
        options['paint'] = { 
          'circle-radius': 2,
          'circle-color': layer.colour,
        }
      } else {
        options['type'] = 'fill'
        options['paint'] = {
          'fill-color': layer.colour,
          'fill-outline-color': 'transparent'
        }
      }

      this.map.addLayer(options, this.firstTopLayerId)
    },

    hideLayers (ids) {
      this.setVisibilityOfLayers(ids, false)
    },

    showLayers (ids) {
      this.setVisibilityOfLayers(ids, true)
    },

    setVisibilityOfLayers (ids, isVisible) {
      if (ids.mapId !== this.id) { return }

      const newVisibility = isVisible ? 'visible' : 'none'

      ids.layerIds.forEach(mapboxLayerId => {
        if(this.map.getLayer(mapboxLayerId)) {
          this.map.setLayoutProperty(mapboxLayerId, "visibility", newVisibility);
        } else if (isVisible) {
          const baseLayer = this.getLayerById(this.getLayerIdFromMapboxLayerId(mapboxLayerId))

          if(baseLayer) { this.addLayer(baseLayer) }
        }
      })
    }
  }
}
</script>