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
import 'lodash';
import { eventHub } from "../../packs/application.js";
import DisplayButtonWithDropdown from "../dropdown/DisplayButtonWithDropdown.vue";

export default {
 name: "SelectText",
 components: {
  DisplayButtonWithDropdown,
 },
 props: {
  text: {
   type: Array,
   required: true,
  },
 },
 mounted() {
  eventHub.$on("option-selected", this.changeText);
 },
 data() {
  return {
   selectedOption: _.isEmpty(this.$store.state.multilingual.selectedLanguage)
    ? this.text[0]
    : this.$store.state.multilingual.selectedLanguage,
   languages: this.text.map((obj) => {
    return obj.locale;
   }),
  };
 },
 methods: {
  changeText(option) {
    const newLanguage = this.text.find((obj) => {
    return obj.locale.iso === option.iso;
   })
   this.$store.dispatch('multilingual/changeLang', newLanguage);
   this.selectedOption = newLanguage;
  },
 },
};
</script>