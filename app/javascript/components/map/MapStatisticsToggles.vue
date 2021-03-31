<template>
  <div class="map__panel-gradient gutters">
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
        :on-a-tab="onATab"
        :set-active="setActive(index)"
        v-on:toggled="toggled"
        :index="index"
        >
          <div class="map__panel-button-wrapper">
            <p class="map__panel-layer-button">
              <span class="map__panel-layer-button-inner"></span>
            </p>
          </div>
          <span v-if="layer.text_small" class="map__panel-layer-text">
            {{ layer.text_small }}
          </span>
          <span v-else class="map__panel-layer-text">{{ layer.text_large }}</span>
        </map-statistics-toggle>
      </li>
    </ul>
  </div>
</template>

<script>
import { eventHub } from "../../packs/application.js"
import { getMapboxLayerIds } from "./map-helpers"
import MapStatisticsToggle from "./MapStatisticsToggle"

export default {
  name: "map-statistics-toggles",

  components: { MapStatisticsToggle },

  props: {
    layers: {
      type: Array,
      required: true,
    },
    mapId: String,
    onATab: {
      default: false,
      type: Boolean
    },
    parentTabId: String
  },

  data() {
    return {
      activeIndices: [0]
    }
  },
  
  mounted () {
    eventHub.$on("change-tab", this.handleTabChange)
  },
  
  beforeDestroy () {
    eventHub.$off("change-tab")
  },

  methods: {
    getMapboxLayerIds (layer) {
      return getMapboxLayerIds(layer)
    },

    handleTabChange (obj) {
      if (this.parentTabId === obj.tab) { return }
      this.activeIndices = [0]
    },

    toggled (obj) {
      obj.isActive ? this.addIndex(obj.index) : this.removeIndex(obj.index)
    },

    addIndex (index) {
      if(!this.activeIndices.includes(index)) {
        this.activeIndices.push(index)
      }
    },

    removeIndex (index) {
      if(this.activeIndices.includes(index)) {
        this.activeIndices = this.activeIndices.filter(i => i !== index )
      }
    },

    setActive (index) {
      return  this.activeIndices.includes(index)
    }
  },
}
</script>