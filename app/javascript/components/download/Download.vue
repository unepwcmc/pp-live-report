<template>
  <div>
    <button 
      title="Download reports in PDF format" 
      class="button--download"
      @click="togglePopup"
    >
      <span class="button--download__text">{{ text }}</span>
      <i class="icon--download"></i>
    </button>
    <div :class="[ isActive ? 'download__target--active' : 'download__target' ]">
      <download-popup
        :options="downloadLinks"
        @downloadStarted="clickDownloadOption"
      />
    </div>
  </div>
</template>

<script>
import DownloadPopup from './DownloadPopup.vue';

export default {
  name: 'Download',
  components: { DownloadPopup },
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
  data() {
    return {
      isActive: false
    }
  },
  methods: {
    togglePopup() {
      this.isActive = !this.isActive
    },
    clickDownloadOption() {
      this.isActive = false
      if (this.$ga) {
        this.$ga.event(this.eventElement, 'Download')
      }
      // window.open(this.downloadUrl, '_blank')
    }
  }
}
</script>