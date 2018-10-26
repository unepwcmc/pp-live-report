<template>
  <div class="chart--doughnut flex">
    <svg class="chart__chart" width="100%" height="100%" viewBox="-300 -300 600 600" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
      <circle cx="0" cy="0" :r="radiusBackground" :fill="colours.grey"></circle>
      
      <g transform="rotate(-26)">
        <g class="chart__segment" v-for="dataset, index in datasets" @click="clickSegment(dataset)"> 
          <path :d="getArcPath(index)" fill="#565656" stroke="#ffffff" stroke-width="3" />

          <text 
            class="chart__segment-text"
            :class
            fill="white"
            :x="getTextX(index)" 
            :y="getTextY(index)" 
            text-anchor="middle" 
            :transform-origin="`${getTextX(index)} ${getTextY(index)}`"
            :transform="getTextRotation(index)">
            {{ index + 1 }}
          </text>
        </g>
      </g>

      <g x="0" y="0">
        <text text-anchor="middle">SDG {{ active.title }}</text>
      </g>
    </svg>

    <div class="chart__side">
      <div class="chart__panel">
        <h3>{{ active.title }}</h3>
        <p>{{ active.description }}</p>
        <a :href="active.url" title="Link to SDG website" target="_blank">Link to SDG website</a>
      </div>
    </div>
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
        },
        active: {
          title: 'test',
          description: '',
          url: ''
        }
      }
    },

    created () {
      this.radiusInner = this.radiusOuter - this.pieceLength
      this.piecePercentage = 100/this.datasets.length
    },

    methods: {
      clickSegment (dataset) {
        this.active.title = dataset.title
        this.active.description = dataset.description
        this.active.url = dataset.url
      },

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
        
        return `rotate(${((percentage/100) * 360) + 90})`
      }
    }
  }  
</script>