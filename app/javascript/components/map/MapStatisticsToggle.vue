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
    },

    computed: {
      toggleClasses () {
        return {
          'active': this.isActive
        }
      }
    },

    methods: {
      handleTabChange (ids) {
        if ('tabs-' + this.mapId !== ids.tabGroup) { return }

        this.parentTabId === ids.tab ? this.showLayers() : this.hideLayers()
      },

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