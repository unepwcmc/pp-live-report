<template>
  <div @click="toggleLayer" class="map__panel-toggle flex flex-v-center" :class="{ 'active': isActive }">
    <slot></slot>
  </div>
</template>

<script>
  export default {
    name: 'map-statistics-toggle',

    data () {
      return {
        isActive: true
      }
    },

    methods: {
      toggleLayer () {
        this.isActive = !this.isActive

        // TODO hide and show the actual layer on the map
      }
    }
  }
</script>