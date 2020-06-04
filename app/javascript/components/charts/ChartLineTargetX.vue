<template>
  <g>
    <path v-if="line" :d="path" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-dasharray="6 8" />
    <path v-else :d="path" :stroke="colour" stroke-width="4" stroke-linecap="round" />

    <text v-if="label" :x="x + 10" :y="`50%`" font-size="16" font-weight="300">
      <tspan v-for="(t, index) in label" :key="`t-${index}`" :x="x + 10" :dy="24">{{ t }}</tspan>
    </text>
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
      label: Array,
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