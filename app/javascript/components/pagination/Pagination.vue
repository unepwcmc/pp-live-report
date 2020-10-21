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
import scrollMagic from "scrollmagic";
import mixinResponsive from "../../mixins/mixinResponsive.js";

export default {
 name: "Pagination",
 mixins: [
  mixinResponsive
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
  this.slideUpOnScroll();
 },
 methods: {
  slideUpOnScroll() {
   //  Set offset to height of panel 
   const offset = document.querySelector('.pagination').offsetHeight;

   const controller = new scrollMagic.Controller();
   const scene = new scrollMagic.Scene({ offset: offset }).setClassToggle(
    ".pagination",
    "show"
   );
   scene.addTo(controller);
  },
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

