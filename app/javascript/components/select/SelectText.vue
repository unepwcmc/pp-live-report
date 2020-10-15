<template>
 <div>
  <div class="multilingual__top-section">
   <h1>{{ selectedOption.title }}</h1>
   <display-button-with-dropdown
    class="button---multilingual"
    :options="languages"
    :selected-option="languages[0]"
   ></display-button-with-dropdown>
  </div>
  <p class="multilingual__text">{{ selectedOption.text }}</p>
 </div>
</template>

<script>
// TODO - wait for topbar + download branch to be merged in first
// import Popup from '../../dropdown/Popup.vue'
import DisplayButtonWithDropdown from "../../dropdown/DisplayButtonWithDropdown.vue";

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
   languages: this.text.map((obj) => { obj.locale })
  };
 },
 methods: {
  changeSelection(selected) {
   this.selected = selected;
  },
 },
};
</script>