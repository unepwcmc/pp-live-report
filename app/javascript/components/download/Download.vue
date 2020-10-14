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
      <popup
        :options="downloadLinks"
        event-element="Individual report download"
        :classes="'download__popup'"
        :showText="false"
        @optionSelected="clickDownloadOption"
      />
    </div>
  </div>
</template>

<script>
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners";
import Popup from '../dropdown/Popup.vue';

export default {
  name: 'Download',
  components: { Popup },
  mixins: [ mixinPopupCloseListeners({closeCallback: 'togglePopup', toggleVariable: 'isActive'}) ],
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
      default: () => (
              [
                { url: 'pdf/Protected_Planet_Report_2018.pdf', title: '2018 report' },
                { url: 'pdf/Test_report.pdf', title: 'test report' }
              ]
      )
    }
  },
  data() {
    return {
      isActive: false
    }
  },
  methods: {
    togglePopup() {
      // if (this.isActive === false) {
      //   this.$ga.event(this.eventElement, 'Download Open')
      // }
      this.isActive = !this.isActive
    },
    clickDownloadOption() {
      this.isActive = false
      // if (this.$ga) {
      //   this.$ga.event(this.eventElement, 'Download Report')
      // }
    }
  }
}
</script>