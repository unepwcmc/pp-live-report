<template>
  <div @click="toggleLayer" :class="['map__panel-toggle no-select', toggleClasses]">
    <slot></slot>
  </div>
</template>

<script>
  import { eventHub } from "../../packs/application.js";

  export default {
    name: 'map-statistics-toggle',

    props: {
      ids: {
        type: Array,
        required: true
      },
      parentTabId: String,
      mapId: String
    },

    data () {
      return {
        isActive: !this.parentTabId || this.parentTabId === 'tab-0',
        isDisabled: true
      }
    },

    created () {
      eventHub.$on('change-tab', this.handleTabChange)
      eventHub.$on('map-loaded', this.handleMapLoaded)
      // eventHub.$on('map-loading-start', this.handleMapLoadingStart)
      // eventHub.$on('map-loading-end', this.handleMapLoadingEnd)
    },

    computed: {
      toggleClasses () {
        return {
          'active': this.isActive,
          'disabled': this.isDisabled
        }
      }
    },

    methods: {
      handleTabChange (ids) {
        if ('tabs-' + this.mapId !== ids.tabGroup) { return }

        this.parentTabId === ids.tab ? this.showLayers() : this.hideLayers()

        this.isDisabled = true
        setTimeout(()=> { this.isDisabled = false }, 1000)
      },

      handleMapLoaded (mapId) {
        if (mapId === this.mapId) {
          this.isDisabled = false
        }
      },

      // handleMapLoadingStart (mapId) {
      //   if (mapId === this.mapId) {
      //     this.isDisabled = true
      //   }
      // },

      // handleMapLoadingEnd (mapId) {
      //   if (mapId === this.mapId) {
      //     this.isDisabled = false
      //   }
      // },

      toggleLayer () {
        this.isActive ? this.hideLayers() : this.showLayers() 
      },

      showLayers () {
        this.isActive = true
        eventHub.$emit('showLayers', {mapId: this.mapId, layerIds: this.ids})
      },

      hideLayers () {
        this.isActive = false
        eventHub.$emit('hideLayers', {mapId: this.mapId, layerIds: this.ids})
      }
    }
  }
</script>