<template>
  <div>
    <button></button>
  </div>
</template>

<script>
  export default {
    name: 'DisplayButtonWithDropdown',
    props: {
      options: {
        type: Array,
        required: true
      },
      selectedOption: {
        type: String,
        required: true
      }
    },
  }
</script>