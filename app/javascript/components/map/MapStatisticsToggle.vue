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
    layerNo: {
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
    eventHub.$on("change-tab", this.handleTabChange);
    eventHub.$on("hide-other-layers", this.hideLayerIfNotSelected);

    if(this.setActive === true) { this.showLayers() }
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
      if ("tabs-" + this.mapId !== ids.tabGroup || !this.isActive ) {
        return;
      }

      this.parentTabId === ids.tab ? this.showLayers() : this.hideLayers();
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
    },

    // hideOtherLayers() {
    //   eventHub.$emit("hide-other-layers", {
    //     mapId: this.mapId,
    //     layerIds: this.ids,
    //     layerNo: this.layerNo,
    //     tab: this.parentTabId
    //   })
    // },

    hideLayerIfNotSelected(obj) {
      if ( obj.layerNo === this.layerNo || obj.mapId !== this.mapId ) { return }
      this.hideLayers();
    }
  }
}
</script>