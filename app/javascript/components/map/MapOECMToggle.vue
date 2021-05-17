<template>
  <div
    class="map-oecm-toggle"
    :class="{ 'map-oecm-toggle--active': isActive }"
    @keyup.enter.stop.prevent="toggle"
    @click.stop="toggle"
  >
    <div class="map-oecm-toggle__switch">
      {{ actionText }}
    </div>
  </div>
</template>

<script>
import { eventHub } from "../../packs/application.js"

export default {
  name: 'MapOECMToggle',
  props: {
    eventElement: {
      type: String,
      default: "",
    },
    onText: {
      type: String,
      default: 'ON',
    },
    offText: {
      type: String,
      default: 'OFF'
    },
    mapId: String,
  },
  
  data() {
    return {
      isActive: false
    }
  },

  computed: {
    actionText () {
      return this.isActive ? this.onText : this.offText;
    }
  },

  mounted () {
    eventHub.$on("change-tab", this.handleTabChange)
  },
  
  beforeDestroy () {
    eventHub.$off("change-tab")
  },

  methods: {
    handleTabChange () {
      this.isActive = false
    },

    toggle () {
      this.isActive = !this.isActive

      this.$emit('toggled', { mapId: this.mapId, includeOecms: this.isActive })

      if(this.$ga) {
        const label = this.isActive ? 'show layers' : 'hide layers'

        // (category, action, label)
        this.$ga.event(this.eventElement, 'click', label)
      }
    }
  }
}
</script>