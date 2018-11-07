<template>
  <g>
    <text v-if="title" :x="minX" :y="y - 10" font-size="18" font-weight="300">{{ title }}</text>
    <path :d="path" :stroke="colour" stroke-width="4" stroke-linecap="round" />
  </g>
</template>

<script>
  export default {
    name: 'chart-line-target-x',

    props: {
      minX: {
        type: Number,
        required: true
      },
      maxX: {
        type: Number,
        required: true
      },
      y: {
        type: Number,
        required: true
      },
      title: String,
      colour: {
        type: String,
        default: '#000000'
      }
    },

    computed: {
      path () {
        return `M ${this.minX} ${this.y} H ${this.maxX}`
      }
    }
  }
</script>