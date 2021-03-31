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
    onATab: {
      default: false,
      type: Boolean
    },
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
    eventHub.$on("oecm-toggle-start", this.handleOecmToggleStart)
    eventHub.$on('oecm-toggle-end', this.handleOecmToggleEnd)

    if(this.setActive === true) { this.showLayers() }
  },
  
  mounted () {

  },

  beforeDestroy() {
    eventHub.$off("change-tab")
    eventHub.$off("oecm-toggle-start")
    eventHub.$off('oecm-toggle-end')
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
        //oecm layers are always reset on tab change
        //do not show layer here if layer is oecm
        //wait for oecm event to avoid race condition issue
        const oecmIds = this.ids.find(id => id.includes('oecm'))

        if(oecmIds === undefined){
          this.showLayers()
        }
      } else {
        this.hideLayers()
      } 
    },

    handleOecmToggleStart (obj) {
      const isOnMap = this.mapId == obj.mapId,
        isOnActiveTab = this.parentTabId == obj.activeTabId,
        isActive = this.isActive

      if(this.onATab === true && !isOnActiveTab) { return }


      if (isOnMap && isActive) {
        this.hideLayers()
      }
    },

    handleOecmToggleEnd (obj) {
      const isOnMap = this.mapId == obj.mapId,
        isOnActiveTab = this.parentTabId == obj.activeTabId,
        shouldBeActive = this.setActive

      if(this.onATab === true) {
        if(!isOnActiveTab) { return }
      }
      
      if (isOnMap && shouldBeActive) {
        this.showLayers()  
      }
    },

    toggleLayer() {
      this.isActive === true ? this.hideLayers() : this.showLayers()

      this.$emit('toggled', { isActive: this.isActive, index: this.index })
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