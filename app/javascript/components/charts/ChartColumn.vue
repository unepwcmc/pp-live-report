<template>
  <div class="chart--column">
    <div class="chart__chart flex flex-h-between">
      <div v-for="column, index in columns" class="chart__column flex flex-column flex-h-end" :style="{ width: width }">
        <span class="chart__percent flex-vs-center">{{ column.value }}</span>
        <span class="chart__bar" :style="{ height: column.percent + '%' }"></span> 

        <p class="chart__label">
          <span class="fw-black">{{ column.label }}</span>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'chart-column',

    props: {
      title: String,
      columns: {
        type: Array,
        required: true
      }
    },

    computed: {
      width () {
        const total = this.columns.length
        return (100/total) - 3 + '%'
      }
    }
  }
</script>