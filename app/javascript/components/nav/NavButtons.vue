<template>
 <div class="flex flex-h-between flex-v-center">
  <div v-if="previousChapter">
   <a
    class="nav__previous"
    :disabled="!previousChapter"
    :href="previousChapter.url"
   ></a>
   <p>{{ previousChapterText }}</p>
  </div>
  <div v-if="nextChapter">
   <p>{{ nextChapterText }}</p>
   <a class="nav__next" :disabled="!nextChapter" :href="nextChapter.url"></a>
  </div>
 </div>
</template>

<script>
export default {
 name: "NavButtons",
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
   return `Chapter ${this.previousChapterNumber}: ${this.previousChapter.title}`;
  },
  nextChapterText() {
   return `Chapter ${this.nextChapterNumber}: ${this.nextChapter.title}`;
  },
 },
};
</script>

