<template>
 <div class="select--text">
  <div class="select--text__top-section">
   <h2 class="select--text__title">{{ selectedOption.title }}</h2>
   <display-button-with-dropdown
    :options="languages"
    :selected-option="languages[0]"
   ></display-button-with-dropdown>
  </div>
  <p class="select--text__text">{{ selectedOption.text }}</p>
 </div>
</template>

<script>
// TODO - wait for topbar + download branch to be merged in first
// import Popup from '../dropdown/Popup.vue'
import DisplayButtonWithDropdown from "../dropdown/DisplayButtonWithDropdown.vue";

export default {
 name: "SelectText",
 components: {
  // Popup,
  DisplayButtonWithDropdown,
 },
 props: {
  text: {
   type: Array,
   required: true,
  },
 },
 data() {
  return {
   selectedOption: this.text[0],
   languages: this.text.map((obj) => { return obj.locale })
  };
 },
 methods: {
  changeSelection(selected) {
   this.selected = selected;
  },
 },
};
</script>