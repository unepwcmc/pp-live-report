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
import { eventHub } from '../../packs/application.js';
import DisplayButtonWithDropdown from "../dropdown/DisplayButtonWithDropdown.vue";

export default {
 name: "SelectText",
 components: {
  DisplayButtonWithDropdown
 },
 props: {
  text: {
   type: Array,
   required: true,
  },
 },
 mounted () {
   eventHub.$on('option-selected', this.changeText);
 },
 data() {
  return {
   selectedOption: this.text[0],
   languages: this.text.map((obj) => { return obj.locale })
  };
 },
 methods: {
  changeText(option) {
    // console.log('success');
    this.selectedOption = this.text.find((obj) => { return obj.locale.iso === option.iso });
  }
 },
};
</script>