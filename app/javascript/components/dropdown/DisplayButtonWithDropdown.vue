<template>
 <div>
  <button class="button--display">
   <span class="button--display text">{{ selectedOption | upcase }}</span>
   <i class="icon--dropdown"></i>
   <!-- Popup goes here -->
  </button>
 </div>
</template>

<script>
export default {
 name: "DisplayButtonWithDropdown",
 props: {
  options: {
   type: Array,
   required: true,
  },
  selectedOption: {
   type: String,
   required: true,
  },
 },
 filters: {
  upcase(value) {
   if (!value) {
    return "";
   }
   return value.toString().toUpperCase();
  },
 },
};
</script>