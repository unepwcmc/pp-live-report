<template>
 <div>
  <a
   v-for="(medium, index) in media"
   :key="index"
   :href="medium.url"
   :class="medium.customClass"
   target="_blank"
  >
  </a>
  <popup :options="media" :classes="'social__popup'" v-if="isMobile"></popup>
 </div>
</template>

<script>
import Popup from "../dropdown/Popup.vue";

export default {
 name: "social-share",
 components: { Popup },
 props: {
  media: {
   type: Array,
   required: true,
  },
 },

 data() {
  return {
   isMobile: false,
   isActive: false
  };
 },
 mounted() {

 },
 methods: {
  toggle() {
   this.isActive = !this.isActive;
  },
 },
};
</script>