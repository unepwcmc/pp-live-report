<template>
  <div class="chart--area">
    <div class="chart__chart flex">
      <div v-for="dataset in datasets" class="chart__dataset" :style="style(dataset.percent)">
        <div class="chart__bar" :class="['chart__bar-' + dataset.class]" :style="{ height: height + 'px' }"></div>
        <span class="chart__label">{{ dataset.title }} {{dataset.percent }}%</span>

        <div v-if="dataset.protected_areas">
          <div class="chart__bar chart__bar-pa" :style="getPaSize(dataset.percent, dataset.protected_areas.percent)"></div>
          <span class="chart__label">{{ dataset.title }} {{dataset.percent }}%</span>
        </div>
      </div>
    </div>

    <chart-legend v-if="legend" :legend="legend"></chart-legend>
  </div>
</template>

<script>
  import ChartLegend from './ChartLegend'

  export default {
    name: 'chart-area',

    components: { ChartLegend },

    props: {
      datasets: {
        type: Array,
        required: true
      },
      legend: Array
    },

    data () {
      return {
        height: 178,
        chartWidth: 0
      }
    },

    mounted () {
      console.log(document.getElementsByClassName('chart--area')[0])
      // this.chartWidth = document.getElementsByClassName('chart--area')[0].clientWidth
    },

    methods: {
      style (percent) {
        return `width: ${percent}%`
      },

      getPaSize (parentWidth, paPercent) {
        console.log(this.chartWidth)
      }
    }
  }
</script>