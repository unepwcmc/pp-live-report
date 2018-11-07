<template>
  <g> 
    <path 
      :d="path" 
      fill="none" 
      :stroke="colour" 
      stroke-width="6" />

    <circle :cx="middle.x" :cy="middle.y" :fill="colour" r="18">{{ index + 1 }}</circle>
    <text :x="middle.x" :y="middle.y" text-anchor="middle" dominant-baseline="middle" font-size="18" font-weight="900" fill="white">{{ index + 1 }}</text>
  </g>
</template>

<script>
  export default {
    name: 'chart-line-dataset',

    props: {
      path: {
        type: String,
        required: true
      },
      index: {
        type: Number,
        required: true
      },
      colour: {
        type: String,
        required: true
      },
      middle: {
        type: Object,
        required: true
      }
    }
  }
</script>