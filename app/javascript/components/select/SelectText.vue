<template>
  <div>
    <div>
      <h1></h1>
      <button></button>
    </div>
    <p></p>
  </div>
</template>

<script>
  export default {
    name: 'SelectText',
      props: {
        text: {
          type: Array,
          required: true
        },
      },
    data() {
      return {
        selectedOption: 0
      }
    },
  }
</script>

