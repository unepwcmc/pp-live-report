<template>
 <div :class="[isActive ? 'modal-wrapper--active' : 'modal-wrapper']">
  <div class="modal-overlay" />
  <div class="modal--case-study">
   <div class="modal__content">
      <button class="modal__close icon--cross" @click.self="closeModal()" />
      <p class="modal__report">{{ text.report }}</p>
      <h2 class="modal__title">{{ text.title }}</h2>
      <p>{{ text.text }}</p>
   </div>
  </div>
 </div>
</template>

<script>
export default {
 name: "Modal",

 props: {
  text: {
   type: Object,
   required: true,
  },
  isActive: {
   type: Boolean,
   required: true,
  },
 },
 methods: {
  closeModal() {
   this.$emit("closeModal");
  },
 },
};
</script>


