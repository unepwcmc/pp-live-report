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
export default {
 name: "PaginationButtons",
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
  };
 },
 computed: {
  previousChapterText() {
   return this.previousChapter ? `Chapter ${this.previousChapterNumber}: ${this.previousChapter.title}` : '';
  },
  nextChapterText() {
   return this.nextChapter ? `Chapter ${this.nextChapterNumber}: ${this.nextChapter.title}` : '';
  },
 },
};
</script>

