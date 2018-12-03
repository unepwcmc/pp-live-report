<template>
  <div class="chart--row">
    <h4 v-if="title" class="chart__title">{{ title }}</h4>

    <div class="chart__chart">
      <div v-for="row in rows" class="chart__row flex flex-v-center flex-h-between" :class="themeClass">
        <span class="chart__bar" :style="{ width: row.percent + '%' }"></span> 
        <span class="chart__percent">{{ row.percent }}%</span>
        <span class="chart__label">{{ row.label }}</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'chart-row',

    props: {
      title: String,
      theme: String,
      rows: {
        type: Array,
        required: true
      }
    },

    computed: {
      themeClass () {
        return `chart-theme--${this.theme}`
      }
    }
  }
</script>