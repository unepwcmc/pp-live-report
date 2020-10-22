<template>
 <div>
  <button class="button--display" @click="togglePopup">
   <span class="button--display text">{{ currentOption.iso | upcase }}</span>
   <i class="icon--dropdown"></i>
   <popup
    v-if="isActive"
    :classes="'display__popup'"
    :show-text="true"
    :is-link="false"
    :options="options"
   ></popup>
  </button>
 </div>
</template>

<script>
import { eventHub } from '../../packs/application.js';
import Popup from "./Popup.vue";

export default {
 name: "DisplayButtonWithDropdown",
 components: {
  Popup,
 },
 props: {
  options: {
   type: Array,
   required: true,
  },
  selectedOption: {
   type: Object,
   required: true,
  },
 },
 mounted() {
   eventHub.$on('option-selected', this.changeSelection);
 },
 data() {
  return {
   isActive: false,
   currentOption: this.selectedOption
  };
 },
 filters: {
  upcase(value) {
   if (!value) {
    return "";
   }
   return value.toString().toUpperCase();
  },
 },
 methods: {
  togglePopup() {
   this.isActive = !this.isActive;
  },
  changeSelection(option) {
    this.currentOption = option;
  }
 },
};
</script>