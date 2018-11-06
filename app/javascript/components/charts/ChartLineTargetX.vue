<template>
  <g>
    <path v-if="line" :d="path" stroke="#871313" stroke-width="1" stroke-linecap="round" stroke-dasharray="4" />
    <path v-else :d="path" :stroke="colour" stroke-width="4" stroke-linecap="round" />
  </g>
</template>

<script>
  export default {
    name: 'chart-line-target-y',

    props: {
      minY: {
        type: Number,
        required: true
      },
      maxY: {
        type: Number,
        required: true
      },
      x: {
        type: Number,
        required: true
      },
      line: Boolean,
      colour: {
        type: String,
        default: '#000000'
      }
    },

    computed: {
      path () {
        return `M ${this.x} ${this.minY} V ${this.maxY}`
      }
    }
  }
</script>