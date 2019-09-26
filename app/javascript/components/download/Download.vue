<template>
  <button 
    title="Download the full report PDF" 
    class="button--download"
    @click="onClick"
  >
    <i class="icon--download"></i>
    <span class="button--download__text">{{ text }}</span>
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
    downloadUrl: {
      type: String,
      required: true
    }
  },

  methods: {
    onClick () {
      if (this.$ga) {
        this.$ga.event(this.eventElement, 'Download')
      }
      window.open(this.downloadUrl, '_blank')
    }
  }
}
</script>