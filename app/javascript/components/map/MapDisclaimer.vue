<template>
 <div>
  <button class="button--grey" @click="openModal">
   <span class="button--grey__text">Map disclaimer</span>
  </button>
  <modal
   :text="disclaimer"
   type="disclaimer"
   :is-active="isActive"
   @close-modal="closeModal"
  ></modal>
 </div>
</template>

<script>
import Modal from '../modal/Modal.vue'

export default {
 name: "MapDisclaimer",
 components: {
   Modal,
 },
 props: {
  disclaimer: {
   type: Object,
   default: () => ({}),
  },
 },
 data() {
  return {
   isActive: false
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