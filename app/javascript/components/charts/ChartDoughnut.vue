<template>
  <div class="chart--doughnut">
    <svg width="100%" height="100%" viewBox="-300 -300 600 600" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" transform="rotate(-90)">
      <circle cx="0" cy="0" :r="radiusBackground" :fill="colours.grey"></circle>
      
      <g v-for="dataset, index in datasets"> 
        <path :d="getArcPath(index)" fill="#565656" stroke="#ffffff" stroke-width="3" />

        <text 
          fill="white"
          :x="getTextX(index)" 
          :y="getTextY(index)" 
          text-anchor="middle" 
          :transform-origin="`${getTextX(index)} ${getTextY(index)}`"
          :transform="getTextRotation(index)">
          {{ dataset.title }}
        </text>
      </g>
    </svg>
  </div>  
</template>

<script>
  export default {
    name: 'chart-doughnut',

    props: {
      datasets: {
        type: Array,
        required: true
      }
    },

    data () {
      return {
        radiusBackground: 300,
        radiusOuter: 286,
        radiusInner: 0,
        radiusText: 240,
        piecePercentage: 0,
        pieceLength: 130,
        colours: {
          grey: '#D8D8D8'
        }
      }
    },

    created () {
      this.radiusInner = this.radiusOuter - this.pieceLength
      this.piecePercentage = 100/this.datasets.length
    },

    methods: {
      getArcPath (index) {
        const 
          start = this.piecePercentage * (index - 1) + .5,
          end = this.piecePercentage * index - .5,
          startX = this.getX(start),
          startY = this.getY(start),
          endX = this.getX(end),
          endY = this.getY(end),
          innerStartX = this.getInnerX(end),
          innerStartY = this.getInnerY(end),
          smallEndX = this.getInnerX(start),
          smallEndY = this.getInnerY(start)

        const sweepFlag = start > 50 ? 1 : 1
        const sweepFlagInner = start > 50 ? 0 : 0

        const d = `M ${startX} ${startY} A ${this.radiusOuter} ${this.radiusOuter} 0 0 1 ${endX} ${endY} L ${innerStartX} ${innerStartY} A ${this.radiusInner} ${this.radiusInner} 0 0 0 ${smallEndX} ${smallEndY} Z`

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
        return this.radiusOuter * Math.cos((percent/100) * 2 * Math.PI)
      },

      getY (percent) {
        // to find x coordinate on a circle r.sin(θ)
        return this.radiusOuter * Math.sin((percent/100) * 2 * Math.PI)
      },

      getTextX (index) {
        const percentage = this.piecePercentage * (index - .5) 

        return this.radiusText * Math.cos((percentage/100) * 2 * Math.PI)
      },

      getTextY (index) {
        const percentage = this.piecePercentage * (index - .5) 

        return this.radiusText * Math.sin((percentage/100) * 2 * Math.PI)
      },

      getTextRotation (index) {
        const percentage = this.piecePercentage * (index - .5) 
        // add 90 degrees to allow for the SVG tag rotation
        return `rotate(${((percentage/100) * 360) + 90})`
      }
    }
  }  
</script>