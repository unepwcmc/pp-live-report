<template>
 <div :class="classes">
  <ul class="ul-unstyled">
   <li v-for="option in options" :key="option._uid">
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
     <span v-html="showTextIfPresent(option)"></span>
    </a>
   </li>
  </ul>
 </div>
</template>

<script>
export default {
 name: "Popup",
 props: {
  classes: String,
  showText: {
   type: Boolean,
   required: true
  },
  options: {
   type: Array,
   default: () => ([])
  },
 },
 methods: {
  clickOption(option) {
   this.$emit("optionSelected", option);
  },
  showTextIfPresent(option) {
   return this.showText ? option.title : "";
  },
 }
};
</script>

