<template>
 <div>
  <button
   title="Download reports in PDF format"
   class="button--download"
   @click="togglePopup"
   aria-haspopup="listbox"
   aria-labelledby="download-text"
  >
   <span class="button--download__text" id="download-text">{{ text }}</span>
   <i class="icon--download"></i>
  </button>
  <div :class="[isActive ? 'download__target--active' : 'download__target']">
   <popup
    :options="downloadLinks"
    :event-element="'Individual report download'"
    :classes="'download__popup'"
    :showText="true"
    @optionSelected="clickDownloadOption(option)"
   />
  </div>
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
  eventElement: {
   type: String,
   default: "",
  },
  downloadLinks: {
   type: Array,
   required: true,
  },
 },
 data() {
  return {
   isActive: false,
  };
 },
 methods: {
  togglePopup() {
   if (this.$ga) {
     this.$ga.event(this.eventElement, 'Download Open');
   }
   this.isActive = !this.isActive;
  },
  clickDownloadOption(option) {
   this.isActive = false;
   if (this.$ga) {
    this.$ga.event(this.eventElement, `${option.title} downloaded`);
   }
  },
 },
};
</script>