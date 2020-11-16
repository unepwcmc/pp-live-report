<template>
 <div class="flex flex-v-center">
  <template v-if="isMobile">
   <button
    @click="togglePopup"
    id="share-button-expand"
    class="button--share icon--share"
    aria-haspopup="listbox"
    aria-label="share-button-expand"
   ></button>
   <div :class="[isActive ? 'social__target--active' : 'social__target']">
    <popup
     :options="media"
     :classes="'social__popup'"
     :showText="false"
     :event-element="'Share button clicked'"
    ></popup>
   </div>
  </template>
  <template v-else>
   <a
    v-for="(medium, index) in media"
    :key="index"
    :href="medium.url"
    :class="medium.customClass"
    target="_blank"
    @click="recordShare(medium.title)"
   >
   </a>
  </template>
 </div>
</template>

<script>
import { eventHub } from "../../packs/application.js"
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners"
import mixinResponsive from "../../mixins/mixin-responsive"
import Popup from "../dropdown/Popup.vue"

export default {
 name: "social-share",
 components: { Popup },
 mixins: [
  mixinResponsive,
  mixinPopupCloseListeners({
   closeCallback: "togglePopup",
   toggleVariable: "isActive",
  }),
 ],
 props: {
  media: {
   type: Array,
   required: true,
  },
  eventElement: {
   type: String,
   default: "",
  },
 },
 mounted() {
  eventHub.$on("link-clicked", this.clickOption)
 },
 data() {
  return {
   isMobile: false,
   isActive: false,
  }
 },
 mounted() {
  this.currentBreakpoint === "small"
   ? (this.isMobile = true)
   : (this.isMobile = false)
 },
 methods: {
  togglePopup() {
   this.isActive = !this.isActive
  },
  clickOption(option) {
   this.isActive = false
   this.recordShare(option.title)
  },
  recordShare(value) {
   if (this.$ga) {
    this.$ga.event(this.eventElement, value)
   }
  },
 },
 watch: {
  currentBreakpoint(val) {
   val === "small" ? (this.isMobile = true) : (this.isMobile = false)
  },
 },
}
</script>