<template>
  <button 
    title="Download the full report PDF" 
    class="button--download"
    @click="onClick"
  >
    <span class="button--download__text">{{ text }}</span>
    <i class="icon--download"></i>
  </button>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      default: ''
    },
    eventElement: {
      type: String,
      default: ''
    },
    downloadLinks: {
      type: Array,
      default: () => ([])
    }
  },

  methods: {
    onClick () {
      // if (this.$ga) {
      //   this.$ga.event(this.eventElement, 'Download')
      // }
      // window.open(this.downloadUrl, '_blank')
    }
  }
}
</script>