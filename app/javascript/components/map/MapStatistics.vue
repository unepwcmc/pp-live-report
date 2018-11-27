<template>
  <div class="map--statistics">
    <div id="map" class="map__map"></div>  

    <div class="map__panel gutters">
      <h2 class="heading--map">{{ title }}</h2>

      <div v-for="layer in layers" class="map__panel-layer">
        <div class="flex flex-v-center" @click="toggleLayer(layer.tables)">
          <div class="map__panel-layer-stat">
            <p class="map__panel-layer-percentage no-margin">
              <span class="map__panel-layer-button"></span>  
              {{ layer.percentage }}%
            </p>
          </div>
          <p class="map__panel-layer-title no-margin">{{ layer.title }}</p>
        </div>

        <template v-if="layer.sublayers">
          <div v-for="sublayer in layer.sublayers" class="flex flex-v-center map__panel-sublayer" @click="toggleLayer(layer.tables)">
            <div class="map__panel-layer-stat">
              <p class="map__panel-sublayer-percentage no-margin">
                <span class="map__panel-sublayer-button"></span>
                {{ sublayer.percentage }}%
              </p>
            </div>
            <p class="map__panel-layer-title no-margin">{{ sublayer.title }}</p>
          </div>
        </template>
      </div>

      <span class="map__source">{{ source }}</span>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'map-statistics',

    props: {
      title: String,
      layers: {
        type: Array,
        required: true
      },
      source: String
    },

    data () {
      return {
        map: {},
        mapboxToken: process.env.MAPBOX_TOKEN,
        cartoUsername: process.env.CARTO_USERNAME,
        cartoApiKey: process.env.CARTO_API_KEY,
        wdpaTables: [process.env.WDPA_POLY_TABLE, process.env.WDPA_POINT_TABLE],
        themes: {
          land: '#86BF37',
          marine: '#03B0DA',
          eez: '#7AB6FF',
          abnj: '#3FD18B'
        }
      }
    },

    mounted () {
      this.createMap()
    },

    methods: {
      createMap () {
        mapboxgl.accessToken = this.mapboxToken

        let map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/unepwcmc/cjo95gdrg0qzh2roan77pelcj',
          center: [0.000000, -0.000000],
          zoom: 1.3
        })

        map.scrollZoom.disable()
        map.addControl(new mapboxgl.NavigationControl({ showCompass: false }), 'top-left')

        this.map = map

        this.addTiles()
      },

      addTiles () {
        let tiles = new cartodb.Tiles({
          user_name: this.cartoUsername,
          tiler_protocol: 'https',
          tiler_port: '443',
          sublayers: [
            {
              sql: this.generateSQL(this.wdpaTables),
              cartocss: '#layer {polygon-fill: #ff00ff}'
            },
            // {
            //   sql: this.generateSQL(this.tables),
            //   cartocss: '#layer {polygon-fill: #ff00ff}'
            // }
          ],
          extra_params: { map_key: this.cartoApiKey }
        })

        tiles.getTiles(object => {
          this.addLayer(tiles, 'layer0', 'wdpa', this.themes.land, false)
          this.addLayer(tiles, 'layer0', 'wdpa-points', this.themes.land, true)
          // this.addLayer(tiles, 'layer1', 'habitat', this.themes[this.theme], false)
          // this.addLayer(tiles, 'layer1', 'habitat-points', this.themes[this.theme], true)
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

      generateSQL (tables) {
        let sqlArray = []

        tables.forEach(table => {
          sqlArray.push(`SELECT cartodb_id, the_geom, the_geom_webmercator FROM ${table}`)
        })

        const sql = sqlArray.join(' UNION ALL ')

        return sql
      },

      toggleLayer (tables) {
        console.log('toggle layer', tables)
      }
    }
  }
</script>4