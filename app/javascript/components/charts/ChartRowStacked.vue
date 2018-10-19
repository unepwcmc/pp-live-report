<template>
  <div class="chart--row-stacked">
    <h3 v-if="title" class="chart__title">{{ title }}</h3>

    <div class="chart__chart flex">
      <p v-for="row in rows" class="chart__bar flex flex-v-center" :style="{ width: row.percent + '%' }">
        <span><strong>{{ row.label }}</strong> {{ row.percent}}%</span>
      </p>
    </div>
    
    <chart-legend v-if="legend" rows="legend"></chart-legend>
  </div>
</template>

<script>
  import ChartLegend from './ChartLegend'

  export default {
    name: 'chart-row-stacked',

    props: {
      title: String,
      rows: {
        type: Array,
        required: true
      },
      legend: {
        type: Array
      }
    }
  }
</script>