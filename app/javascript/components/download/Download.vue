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
   if (this.$ga) {
    this.$ga.event(this.eventElement, 'Download Open')
   }
   this.isActive = !this.isActive
  },
  clickDownloadOption(option) {
   this.isActive = false
   if (this.$ga) {
    this.$ga.event(this.eventElement, option.title + ' ' + 'downloaded')
   }
  },
 },
}
</script>