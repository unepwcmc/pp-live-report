<template>
 <button
  :title="`View the case study: ${caseStudy.title}`"
  class="card--case-study"
  @click="openModal"
 >
  <modal
   :text="caseStudy"
   :is-active="isActive"
   @close-modal="closeModal"
  ></modal>
  <div class="card__image"></div>
  <div class="card__overlay">
   <h2 class="card__title">{{ caseStudy.title }}</h2>
   <p class="card__summary">{{ caseStudy.summary }}</p>
   <i class="icon--circle-chevron-white"></i>
  </div>
 </button>
</template>

<script>
import Modal from "../modal/Modal.vue";

export default {
 name: "CardImage",
 components: {
  Modal,
 },
 props: {
  caseStudy: {
   type: Object,
   required: true,
  },
 },
 data() {
  return {
   isActive: false,
  };
 },
 methods: {
  openModal() {
   this.isActive = true;
  },
  closeModal() {
   this.isActive = false;
  },
 },
};
</script>