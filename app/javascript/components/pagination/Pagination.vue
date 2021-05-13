<template>
 <div class="pagination__panel">
   <div class="pagination__previous">
      <a
        v-if="previousChapter"  
        @click="clickPrevious"
        class="pagination__link" 
        :href="previousChapter"
      >
        <i class="icon--previous"></i>
        <p class="pagination__text">{{ previousChapterText }}</p>
    </a>
  </div>
  <div class="pagination__next">
    <a
      v-if="nextChapter"  
      @click="clickNext"
      class="pagination__link"
      :href="nextChapter"
      >
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
    eventElement: {
      type: String,
      default: "",
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

    clickPrevious () {
      if(this.$ga) {
        this.track(`Go to previous page: ${this.previousChapterText}`)
      }
    },

    clickNext () {
      console.log('next')
      if(this.$ga) {
        this.track(`Go to next page: ${this.nextChapterText}`)
      }
    },

    track (label) {
      this.$ga.event(this.eventElement, 'click', label)
    }
  }
}
</script>

