<template>
  <div
    @click="toggleLayer"
    :class="['map__panel-toggle no-select', toggleClasses]"
  >
    <slot></slot>
  </div>
</template>

<script>
import { eventHub } from "../../packs/application.js";

export default {
  name: "map-statistics-toggle",

  props: {
    // isActive: {
    //   type: Boolean,
    // },
    ids: {
      type: Array,
      required: true,
    },
    index: {
      type: Number,
      required: true,
    },
    parentTabId: String,
    mapId: String,
    setActive: {
      type: Boolean,
    },
  },

  data() {
    return {
      isActive: false,
      isDisabled: true,
    }
  },

  created() {
    eventHub.$on("change-tab", this.handleTabChange)

    if(this.setActive === true) { this.showLayers() }
  },

  beforeDestroy() {
    eventHub.$off("change-tab")
  },

  computed: {
    toggleClasses() {
      return {
        active: this.isActive,
      }
    },
  },

  methods: {
    handleTabChange(ids) {
      if ("tabs-" + this.mapId !== ids.tabGroup) {
        return
      }

      if(this.parentTabId === ids.tab && this.index === 0) {
        this.showLayers()
      } else {
        this.hideLayers()
      } 
    },

    toggleLayer() {
      this.isActive === true ? this.hideLayers() : this.showLayers()
    },

    showLayers() {
      eventHub.$emit("show-layers", { mapId: this.mapId, layerIds: this.ids })
      this.isActive = true
    },

    hideLayers() {
      eventHub.$emit("hide-layers", { mapId: this.mapId, layerIds: this.ids })  
      this.isActive = false
    }
  }
}
</script>