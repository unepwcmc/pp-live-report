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
    :class="[isActive ? 'download__target--active' : 'download__target']"
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
    <button
    :title="title"
    class="button--download"
    @click="downloadFile"
    aria-labelledby="download-text"
    >
      <span class="button--download__text" id="download-text">{{ text }}</span>
      <i class="icon--download"></i>
    </button>
  </template>
 </div>
</template>

<script>
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners";
import Popup from "../dropdown/Popup.vue";

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
   type: Boolean,
   default: false
  },
  downloadLinks: {
   type: Array,
  },
 },
 data() {
  return {
   isActive: false,
  };
 },
 methods: {
  downloadFile() {},
  togglePopup() {
   if (this.$ga) {
    this.$ga.event(this.eventElement, "Download Open");
   }
   this.isActive = !this.isActive;
  },
  clickDownloadOption(option) {
   this.isActive = false;
   if (this.$ga) {
    this.$ga.event(this.eventElement, option.title + " " + "downloaded");
   }
  },
 },
};
</script>