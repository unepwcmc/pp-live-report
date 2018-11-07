<template>
  <ul class="chart--legend ul-unstyled flex flex-wrap">
    <li v-for="row, index in rows" class="chart__legend-item flex flex-v-center" :class="themeClass">
      <span v-if="row.line" class="chart__legend-key" :style="lineStyle"></span>
      <span v-else class="chart__legend-key" :style="style(index)"></span>
      <span class="chart__legend-text fw-black">{{ index + 1 }}.</span> 
      <span class="chart__legend-text">{{ row.title }}</span>
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
      },
      theme: String,
      colours: Array
    },

    data () {
      return {
        lineStyle: {
          'border-top': 'dashed 1px #871313',
          'background-color': 'transparent',
          'height': 0
        }
      }
    },

    computed: {
      themeClass () {
        return `theme--${this.theme}`
      }
    },

    methods: {
      style (index) {
        let styling = ''

        if(this.colours) {
          styling = `background-color: ${this.colours[index]}`
        }

        return styling
      }
    }
  }
</script>