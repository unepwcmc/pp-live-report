<template>
  <div>
    <template v-if="downloadLinks">
      <button
        :title="title"
        class="button--download"
        @click="togglePopup"
        aria-haspopup="listbox"
        aria-labelledby="download-text"
        >
        <span class="button--download__text" id="download-text">{{ text }}</span>
        <i class="icon--download"></i>
      </button>
      <div
        :class="['download__target', { 'active' : isActive }]"
      >
        <popup
          :options="downloadLinks"
          :event-element="'Individual report download'"
          :classes="'download__popup'"
          :showText="true"
          @optionSelected="clickDownloadOption"
        />
      </div>
    </template>
    <template v-else-if="fileDownload">
      <a
        :title="title"
        class="button--download"
        target="_blank"
        :href="fileDownload"
        aria-labelledby="download-text"
        @click="clickDownload"
      >
        <span class="button--download__text" id="download-text">{{ text }}</span>
        <i class="icon--download"></i>
      </a>
    </template>
  </div>
</template>

<script>
import { eventHub } from '../../packs/application.js'
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners"
import Popup from "../dropdown/Popup.vue"

export default {
  name: "Download",
  components: { Popup },
  mixins: [
    mixinPopupCloseListeners({
      closeCallback: "togglePopup",
      toggleVariable: "isActive",
    }),
  ],
  props: {
    text: {
      type: String,
      default: "",
    },
    title: {
      type: String,
      default: "",
    },
    eventElement: {
      type: String,
      default: "",
    },
    fileDownload: {
      type: String,
      default: ""
    },
    downloadLinks: {
      type: Array
    },
  },
  mounted() {
    eventHub.$on('link-clicked', this.clickDownloadOption)
  },
  data() {
    return {
      isActive: false,
    }
  },
  methods: {
    togglePopup() {
      this.isActive = !this.isActive
   
      if (this.$ga) {
        const label = this.isActive ? 'open' : 'close'
        // (category, action, label)
        this.$ga.event(this.eventElement, 'click', label)
      }
    },
    clickDownloadOption(option) {
      if (this.$ga) {
        //(category, action, label)
        this.$ga.event(`${this.eventElement} - Download PDF`, 'click', option.title)
      }
    },
    clickDownload() {
      if (this.$ga) {
        //(category, action, label)
        this.$ga.event(this.eventElement, 'click', this.fileDownload)
      }
    }
  },
}
</script>