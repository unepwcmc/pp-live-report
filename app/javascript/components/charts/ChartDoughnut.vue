<template>
  <div class="chart--doughnut">
    <svg width="100%" height="100%" viewBox="-300 -300 600 600" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" transform="rotate(-90)">
      <circle cx="0" cy="0" :r="radius" :fill="colours.grey"></circle>
      <circle :cx="getX()" :cy="getY()" r="4"></circle>

      <circle :cx="getInnerX(0)" :cy="getInnerY(0)" r="4"></circle>

      <path :d="getArcPath(0, 20)" fill="#565656" stroke="#ff0000"/>
      <path :d="getArcPath(30, 33)" fill="#565656" stroke="#ff0000"/>
      <path :d="getArcPath(40, 60)" fill="#565656" stroke="#ff0000"/>
      <path :d="getArcPath(80, 82)" fill="#565656" stroke="#ff0000"/>
    </svg>
  </div>  
</template>

<script>
  export default {
    name: 'chart-doughnut',

    props: {
      dataset: {
        type: Array,
        required: true
      }
    },

    data () {
      return {
        radius: 300,
        radiusInner: 0,
        pieceLength: 130,
        colours: {
          grey: '#D8D8D8'
        }
      }
    },

    created () {
      this.radiusInner = this.radius - this.pieceLength
    },

    methods: {
      getArcPath (start, end) {
        const startX = this.getX(start),
          startY = this.getY(start),
          endX = this.getX(end),
          endY = this.getY(end),
          innerStartX = this.getInnerX(end),
          innerStartY = this.getInnerY(end),
          smallEndX = this.getInnerX(start),
          smallEndY = this.getInnerY(start)

        const sweepFlag = start > 50 ? 0 : 1
        const sweepFlagInner = start > 50 ? 1 : 0

        const d = `M ${startX} ${startY} A ${this.radius} ${this.radius} 0 0 ${sweepFlag} ${endX} ${endY} L ${innerStartX} ${innerStartY} A ${this.radiusInner} ${this.radiusInner} 0 0 ${sweepFlagInner} ${smallEndX} ${smallEndY} Z`

        return d
      },

      getInnerX (percent) {
        // to find x coordinate on a circle r.cos(θ)
        return this.radiusInner * Math.cos((percent/100) * 2 * Math.PI)
      },

      getInnerY (percent) {
        // to find x coordinate on a circle r.sin(θ)
        return this.radiusInner * Math.sin((percent/100) * 2 * Math.PI)
      },

      getX (percent) {
        // to find x coordinate on a circle r.cos(θ)
        return this.radius * Math.cos((percent/100) * 2 * Math.PI)
      },

      getY (percent) {
        // to find x coordinate on a circle r.sin(θ)
        return this.radius * Math.sin((percent/100) * 2 * Math.PI)
      }
    }
  }  
</script>