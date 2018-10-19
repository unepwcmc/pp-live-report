<template>
  <div class="chart--legend flex">
    <p v-for="row in rows" class="chart__legend-item flex">
      <span class="chart__legend-key"></span>{{ row.title }}
    </p>
  </div>
</template>

<script>
  export default {
    name: 'chart-legend',

    props: {
      rows: {
        type: Array,
        required: true
      }
    }
  }
</script>