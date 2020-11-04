<template>
  <div
    class="map-oecm-toggle"
    tabindex="0"
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
export default {
  name: 'MapOECMToggle',
  props: {
    gaId: {
      type: String
    },
    onText: {
      type: String,
      default: 'ON',
    },
    offText: {
      type: String,
      default: 'OFF'
    }
  },
  data() {
    return {
      isActive: false
    }
  },
  computed: {
    actionText () {
      if (this.isActive) {
        return this.onText
      }

      return this.offText
    }
  },
  methods: {
    toggle () {
      this.isActive = !this.isActive

      this.$emit('change', this.isActive)

      if(this.gaId) {
        this.$ga.event(`Toggle - Show map layer: ${this.isActive}`, 'click', this.gaId)
      }
    }
  }
}
</script>