<template>
  <g>
    <path v-if="line" :d="path" stroke="#871313" stroke-width="1" stroke-linecap="round" stroke-dasharray="4" />
    <path v-else :d="path" :stroke="colour" stroke-width="4" stroke-linecap="round" />

    <text v-if="label" :x="x + 10" :y="maxY + 10" font-size="18" font-weight="300">
      <tspan v-for="t in label" :x="x + 10" :dy="24">{{ t }}</tspan>
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
      label: String,
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