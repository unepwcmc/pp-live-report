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
      cartoUsername: process.env.CARTO_USERNAME,
      cartoApiKey: process.env.CARTO_API_KEY,
      allLayers: []
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

      const map = new mapboxgl.Map({
        container: this.id,
        style: 'mapbox://styles/unepwcmc/cjo95gdrg0qzh2roan77pelcj',
        center: [0.000000, -0.000000],
        zoom: 1.3
      })

      map.scrollZoom.disable()
      map.addControl(new mapboxgl.NavigationControl({ showCompass: false }), 'top-left')
      map.on("load", () => { this.createInitialLayers() })

      this.map = map
    },

    createInitialLayers () {
      if (this.initialLayers.length) {
        this.createLayers(this.initialLayers)
      }
    },

    createLayers (layers) {
      layers.forEach(layer => { this.createLayerAndSubLayers(layer) })
    },

    createLayerAndSubLayers (layer) {
      this.createLayer(layer)

      if(layer.sublayers) {
        layer.sublayers.forEach(sublayer => {
          this.createLayer(sublayer)
        })
      }
    },

    createLayer (layer) {
      if (layer.sql) { 
        this.addCartoVectorLayer(layer) 
      } else if (layer.wmsUrl) {
        this.addRasterLayer(layer)
      } else if (layer.source_layer && this.tilesUrl) {
        this.addVectorLayerByUrl(layer)
      }
    },

    addCartoVectorLayer (layer) {
      const tiles = new cartodb.Tiles({
        user_name: this.cartoUsername,
        tiler_protocol: 'https',
        tiler_port: '443',
        sublayers: [
          {
            sql: layer.sql,
            cartocss: '#layer {polygon-fill: #ff00ff}'
          }
        ],
        extra_params: { map_key: this.cartoApiKey }
      })

      tiles.getTiles(object => {
        this.addVectorLayer(tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles, 'layer0', layer.id + '-polys', layer.colour, false)
        this.addVectorLayer(tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles, 'layer0', layer.id + '-points', layer.colour, true)
      })
    },

    addVectorLayerByUrl (layer) {
      this.addVectorLayer([this.tilesUrl], layer.source_layer, layer.id, layer.colour, false, layer.filter_id)
    },

    addVectorLayer (tiles, source, id, colour, point, filterId) {
      const options = {
        'id': id,
        'source': {
          'type': 'vector',
          'tiles': tiles
        },
        'source-layer': source,
        'filter': filterId ? ['==', '_symbol', filterId] : ['all']
      }

      if(point){
        options['type'] = 'circle'
        options['paint'] = { 'circle-radius': 2, 'circle-color': colour, 'circle-opacity': .8 }
        options['filter'] = ['==', '$type', 'Point']
      } else {
        options['type'] = 'fill'
        options['paint'] = { 'fill-color': colour, 'fill-opacity': .8, 'fill-outline-color': 'transparent' }
      }

      this.map.addLayer(options)
    },

    addRasterLayer (layer) {
      const options = {
        'id': layer.id,
        'type': 'raster',
        'minzoom': 0,
        'maxzoom': 10,
        'source': {
          'type': 'raster',
          'tiles': [layer.wmsUrl],
          'tileSize': 64
        },
        'paint': {
          'raster-opacity': 0.8,
          'raster-hue-rotate': 0
        }
      }

      this.map.addLayer(options)
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

      ids.layerIds.forEach(id => {
        if(this.map.getLayer(id)) {
          this.map.setLayoutProperty(id, "visibility", newVisibility);
        } else if (isVisible && this.getLayerById(id)) {
          this.createLayer(this.getLayerById(id))
        }
      })
    }
  }
}
</script>