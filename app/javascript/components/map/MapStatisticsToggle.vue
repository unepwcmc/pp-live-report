<template>
  <div @click="toggleLayer" class="map__panel-toggle no-select" :class="{ 'active': isActive }">
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
      }
    },

    data () {
      return {
        isActive: true
      }
    },

    methods: {
      toggleLayer () {
        eventHub.$emit('toggleLayer', this.ids)
        this.isActive = !this.isActive
      }
    }
  }
</script>