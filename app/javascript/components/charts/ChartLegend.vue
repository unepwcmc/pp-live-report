<template>
  <ul class="chart--legend ul-unstyled flex">
    <li v-for="row in rows" class="chart__legend-item flex">
      <span class="chart__legend-key"></span>{{ row.title }}
    </li>
  </ul>
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