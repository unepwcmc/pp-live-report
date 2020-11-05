<template>
 <div>
  <button class="button--grey">
   <span class="button--grey__text">Map disclaimer</span>
  </button>
  <!-- Modal component needs to go here for map disclaimer -->
 </div>
</template>

<script>
export default {
 name: "MapDisclaimer",
 props: {
  disclaimer: {
   type: Object,
   default: () => ({}),
  },
 },
};
</script>