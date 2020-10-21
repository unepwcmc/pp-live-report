<template>
 <div :class="[ isActive ? 'modal-wrapper--active' : 'modal-wrapper' ]">
  <div v-if="isActive" class="modal--case-study">
   <button class="modal__close icon--cross" @click.stop="modalClose" />
   <div class="modal__content">
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
   isActive: {
     type: Boolean,
     required: true
   },
  text: {
   type: Object,
   required: true,
  }
 },
 methods: {
  modalClose() {
    this.$emit('close-modal');
  },
 },
};
</script>


