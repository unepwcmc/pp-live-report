<template>
  <div class="chart--doughnut flex">
    <svg class="chart__chart" width="100%" height="100%" viewBox="-340 -340 680 680" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
      <circle cx="0" cy="0" :r="radiusBackground" :fill="colours.grey"></circle>
      
      <g transform="rotate(-26)">

        <g v-for="dataset, index in datasets" 
          @click="clickSegment(dataset)"
          class="chart__segment"
          :class="{ 'active': getSegmentStatus(dataset.title) }"> 

          <path class="chart__segment-path" :d="getArcPath(index)" :fill="dataset.colour" stroke="#ffffff" />

          <text 
            class="chart__segment-text"
            fill="white"
            :x="getTextX(index)" 
            :y="getTextY(index)" 
            text-anchor="middle"
            font-size="25px"
            :transform-origin="`${getTextX(index)} ${getTextY(index)}`"
            :transform="getTextRotation(index)">
            {{ index + 1 }}
          </text>
        </g>
      </g>

      <g x="0" y="0">
        <text text-anchor="middle">{{ active.title }}</text>
      </g>
    </svg>

    <div class="chart__side">
      <div class="chart__panel" :style="{ 'background-color': active.colour}">
        <h3>{{ active.title }}</h3>
        <p>{{ active.description }}</p>
        <a :href="active.url" title="Link to SDG website" target="_blank">Link to SDG website</a>
      </div>

      <p v-if="smallprint">{{ smallprint }}</p>
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
      },
      smallprint: String
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
          grey: '#ededed',
        },
        active: {
          title: 'test',
          description: '',
          url: '',
          colour: ''
        }
      }
    },

    created () {
      this.radiusInner = this.radiusOuter - this.pieceLength
      this.piecePercentage = 100/this.datasets.length

      this.active.title = this.datasets[0].title
      this.active.description = this.datasets[0].description
      this.active.url = this.datasets[0].url
      this.active.colour = this.datasets[0].colour
    },

    methods: {
      clickSegment (dataset) {
        this.active.title = dataset.title
        this.active.description = dataset.description
        this.active.url = dataset.url
        this.active.colour = dataset.colour
      },

      getStrokeWidth (title) {
        return title == this.active.title ? 5 : 0
      },

      getSegmentStatus (title) {
        return title == this.active.title
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