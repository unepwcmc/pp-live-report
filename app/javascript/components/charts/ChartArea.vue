<template>
  <div class="chart--area">
    <div class="chart__chart flex">
      <div v-for="(dataset, index) in datasets" :key="`chart-${index}`" class="chart__dataset" :style="style(dataset.cssPercent)">
        <div class="chart__bar" :class="['chart__bar-' + dataset.class]" :style="{ height: height + 'px' }">
          <p class="chart__label no-margin">{{ dataset.title }} <span class="chart__label-percentage">{{dataset.percent }}%</span></p>
        </div>

        <div v-if="dataset.protected_areas">
          <div class="chart__bar chart__bar-pa" :style="getPaSize(dataset.cssPercent, dataset.protected_areas.percent)">
            <p class="chart__label-pa no-margin">{{ dataset.protected_areas.title }} <span class="chart__label-percentage">{{dataset.protected_areas.percent }}%</span></p>
          </div>
        </div>
      </div>
    </div>

    <chart-legend v-if="legend" :rows="legend"></chart-legend>
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
      id: {
        type: String,
        required: true
      },
      legend: Array,
    },

    data () {
      return {
        height: 180,
        chartWidth: 0
      }
    },

    mounted () {
      this.chartWidth = document.querySelector(`[${this.id}]`).clientWidth
    },

    methods: {
      style (percent) {
        return `width: ${percent}%`
      },

      getNestedDatasetWidth () {

      },

      getPaSize (parentPercent, paPercent) {
        const parentArea = this.chartWidth * this.height * (parentPercent/100),
          paArea = parentArea * (paPercent/100),
          paAreaLength = Math.round(Math.sqrt(paArea))

        return { width: `${paAreaLength}px`, height: `${paAreaLength}px` }
      }
    }
  }
</script>