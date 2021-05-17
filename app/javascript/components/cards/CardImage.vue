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
    <span 
      class="card__image"
      v-bind:style="`background-image: url('${caseStudy.card_image}')`"
    />
    <span class="card__image-overlay" />
    <p class="card__label">{{ caseStudy.label }}</p>
    <h2 class="heading--card">{{ caseStudy.title }}</h2>
    <i class="icon--circle-chevron-white"></i>
  </button>
</template>

<script>
import Modal from "../modal/Modal.vue"

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
    }
  },
  methods: {
    openModal() {
      this.isActive = true
    },
    closeModal() {
      this.isActive = false
    },
  },
};
</script>