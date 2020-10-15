<template>
 <div class="pagination__panel">
  <div class="pagination__previous">
   <a
    class="button--previous"
    v-if="previousChapter"
    :href="previousChapter.url"
   ></a>
   <p class="pagination__text">{{ previousChapterText }}</p>
  </div>
  <div class="pagination__next">
   <p class="pagination__text">{{ nextChapterText }}</p>
   <a class="button--next" v-if="nextChapter" :href="nextChapter.url"></a>
  </div>
 </div>
</template>

<script>
// TODO - I want to import SASS variables from the pagination partial stylesheet
// so I can use them as the offset variable and control is placed in the hands of 
// SCSS rather than allowing the offset to be arbitrarily set here in the component

import mixinResponsive from "../../mixins/mixinResponsive.js";
import mixinSlideOut from "../../mixins/mixinSlideOut.js";

export default {
 name: "Pagination",
 mixins: [
  mixinResponsive,
  mixinSlideOut({
   className: ".pagination",
   offset: '-74px' // NB: This offset should match the height of the button bar for best results
  }),
 ],
 props: {
  currentChapter: {
   type: Number,
   required: true,
  },
  previousChapter: {
   type: [Object, Boolean],
   required: true,
  },
  nextChapter: {
   type: [Object, Boolean],
   required: true,
  },
 },
 data() {
  return {
   previousChapterNumber: this.currentChapter - 1,
   nextChapterNumber: this.currentChapter + 1,
   isMobile: false,
  };
 },
 mounted() {
  this.isMobile = this.currentBreakpoint === "small" ? true : false;
 },
 computed: {
  previousChapterText() {
   if (this.previousChapter && this.isMobile) {
    return "Previous";
   }
   return this.previousChapter
    ? `Chapter ${this.previousChapterNumber}: ${this.previousChapter.title}`
    : "";
  },
  nextChapterText() {
   if (this.nextChapter && this.isMobile) {
    return "Next";
   }
   return this.nextChapter
    ? `Chapter ${this.nextChapterNumber}: ${this.nextChapter.title}`
    : "";
  },
 },
 watch: {
  currentBreakpoint(val) {
   this.isMobile = val === "small" ? true : false;
  },
 },
};
</script>

