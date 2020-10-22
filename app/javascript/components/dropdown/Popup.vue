<template>
 <div :class="classes">
  <ul class="ul-unstyled" role="listbox">
   <li
    v-for="option in options"
    :key="option._uid"
    role="option"
    aria-labelledby="option-text"
   >
    <template v-if="isLink">
     <a
      :class="[
       option.hasOwnProperty('customClass')
        ? option.customClass
        : 'download__link',
      ]"
      :href="option.url"
      target="_blank"
      :title="option.title"
      @click="clickOption(option)"
     >
      <span id="option-text" v-html="showTextIfPresent(option)"></span>
     </a>
    </template>
    <template v-else>
     <span
      id="option-text"
      v-html="showTextIfPresent(option)"
      @click="clickOption(option)"
     ></span>
    </template>
   </li>
  </ul>
 </div>
</template>

<script>
import { eventHub } from '../../packs/application.js';

export default {
 name: "Popup",
 props: {
  classes: String,
  showText: {
   type: Boolean,
   required: true,
  },
  options: {
   type: Array,
   default: () => ([]),
  },
  isLink: {
   type: Boolean,
   default: true,
  },
 },
 methods: {
  clickOption(option) {
   eventHub.$emit("option-selected", option);
  },
  showTextIfPresent(option) {
   return this.showText ? option.title : "";
  },
 },
};
</script>

