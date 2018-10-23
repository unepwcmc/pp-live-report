<template>
  <ul class="chart--legend ul-unstyled flex">
    <li v-for="row, index in rows" class="chart__legend-item flex">
      <span class="chart__legend-key" :style="style(index)"></span>{{ row.title }}
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
      colours: Array
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