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
      source: String
    },

    data () {
      return {
        map: {},
        mapboxToken: process.env.MAPBOX_TOKEN,
        cartoUsername: process.env.CARTO_USERNAME,
        cartoApiKey: process.env.CARTO_API_KEY,
        wdpaTables: [process.env.WDPA_POLY_TABLE, process.env.WDPA_POINT_TABLE],
        allLayers: [],
        isLoading: true
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

        let map = new mapboxgl.Map({
          container: this.id,
          style: 'mapbox://styles/unepwcmc/cjo95gdrg0qzh2roan77pelcj',
          center: [0.000000, -0.000000],
          zoom: 1.3
        })

        map.scrollZoom.disable()
        map.addControl(new mapboxgl.NavigationControl({ showCompass: false }), 'top-left')

        map.on("load", () => {
          this.createInitialLayers()
          
          setTimeout(() => {
            eventHub.$emit("map-loaded", this.id)
          }, 1000)
        })

        // let timeoutHandle = {}
        // let isLoading = false
        // const resetLoadingTimeout = () => {
        //   clearTimeout(timeoutHandle)
        //   timeoutHandle = setTimeout(() => {
        //     isLoading = false
        //     eventHub.$emit("map-loading-end", this.id)
        //   }, 800)
        // }
        
        // map.on("sourcedataloading", () => {
        //   if (!isLoading) { 
        //     isLoading = true
        //     eventHub.$emit("map-loading-start", this.id)
        //     resetLoadingTimeout()
        //   } else {
        //     resetLoadingTimeout()
        //   }
        // })

        this.map = map
      },

      createInitialLayers () {
        if (this.initialLayers.length) {
          this.createLayers(this.initialLayers)
        }
      },

      createLayers (layers) {
        layers.forEach(layer => { this.createLayer(layer) })
      },

      createLayer (layer) {
        if(layer.sql) { this.createVectorTiles(layer) }
        if(layer.wmsUrl) { this.createRasterLayer(layer) }

        if(layer.sublayers) {
          layer.sublayers.forEach(sublayer => {
            if(layer.sql) { this.createVectorTiles(sublayer) }
            if(layer.wmsUrl) { this.createRasterLayer(sublayer) }
          })
        }
      },

      createVectorTiles (layer) {
        let tiles = new cartodb.Tiles({
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
          this.addLayer(tiles, 'layer0', layer.id + '-polys', layer.colour, false)
          this.addLayer(tiles, 'layer0', layer.id + '-points', layer.colour, true)
        })
      },

      addLayer (tiles, source, id, colour, point) {
        let options = {
          'id': id,
          'source': {
            'type': 'vector',
            'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
          },
          'source-layer': source
        }

        if(point){
          options['type'] = 'circle'
          options['paint'] = { 'circle-radius': 2, 'circle-color': colour, 'circle-opacity': .8 }
          options['filter'] = ['==', '$type', 'Point']
        } else {
          options['type'] = 'fill'
          options['paint'] = { 'fill-color': colour, 'fill-opacity': .8 }
        }

        this.map.addLayer(options)
      },

      createRasterLayer (layer) {
        let options = {
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