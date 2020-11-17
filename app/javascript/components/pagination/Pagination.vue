<template>
 <div class="pagination__panel">
   <div class="pagination__previous">
    <a class="pagination__link" v-if="previousChapter" :href="previousChapter">
    <i
      class="icon--previous"
    ></i>
    <p class="pagination__text">{{ previousChapterText }}</p>
    </a>
  </div>
  <div class="pagination__next">
    <a class="pagination__link" v-if="nextChapter" :href="nextChapter">
      <p class="pagination__text">{{ nextChapterText }}</p>
      <i class="icon--next" ></i>
    </a>
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
   type: [String, Boolean],
   required: true,
  },
  nextChapter: {
   type: [String, Boolean],
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
   return this.previousChapter ? `Chapter ${this.previousChapterNumber}`: "";
  },
  nextChapterText() {
   if (this.nextChapter && this.isMobile) {
    return "Next";
   }
   return this.nextChapter ? `Chapter ${this.nextChapterNumber}` : "";
  },
 },
 watch: {
  currentBreakpoint(val) {
   this.isMobile = val === "small" ? true : false;
  },
 },
};
</script>

