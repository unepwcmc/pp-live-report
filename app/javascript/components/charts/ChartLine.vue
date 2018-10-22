<template>
  <div>
    <div v-if="lines">
      <div class="issues-chart__svg">
        <svg width="100%" height="100%" viewBox="0 0 1000 550" xmlns="http://www.w3.org/2000/svg">
          <!--
          Offset first path point ever so slightly so it gets a bounding box
          http://www.w3.org/TR/SVG11/coords.html#ObjectBoundingBox
          -->
          <!-- <path :d="getPath()" fill="none" stroke="url(#lineGradient)" stroke-width="4"/>

          <circle v-if="!isFirstYear()" cx="60" :cy="normaliseValue(getFirstValue().issuesReported)" r="4" fill="#4D6B89" stroke="#fff" stroke-width="2"/>
          <circle cx="200" :cy="normaliseValue(getSecondValue().issuesReported)" r="4" fill="#4D6B89" stroke="#fff" stroke-width="2"/>
          <circle v-if="!isLastYear()" cx="340" :cy="normaliseValue(getThirdValue().issuesReported)" r="4" fill="#4D6B89" stroke="#fff" stroke-width="2"/> -->

          <rect x="220" y="0" width="890" height="500" fill="#EBEBEB" />

          <rect x="220" y="0" width="120px" height="440" fill="#CCCBCB" rx="4" ry="4" />

          <path v-for="line in lines" :d="getPath(line.datapoints)" fill="none" stroke="#1D7DA6" stroke-width="6" />

          <g>
            <text v-for="y in yAxis" :x="offsetX" :y="y.coord">{{ y.labelText }}</text>
            <text v-for="x in xAxis" :x="x.coord" :y="maxSvgY">{{ x.labelText }}</text>
          </g>
        </svg>
      </div>
    </div>
  </div>  
</template>

<script>
  export default {
    name: 'chart-line',

    props: {
      lines: {
        type: Array,
        required: true
      }
    },

    data () {
      return {
        precision: 10,
        maxSvgX: 890,
        maxSvgY: 500,
        offsetX: 220,
        offsetY: 0,
        minX: 0,
        maxX: 0,
        minY: 0,
        maxY: 0
      }
    },

    computed: {
      yAxis () {
        let array = [], y = 0
        const incrementor = this.maxY / 8

        while( y < this.maxY ) {
          array.push({
            coord: this.normaliseY(y),
            labelText: Math.round(y/this.precision)*this.precision
          })

          y += incrementor
        }

        console.log(array)

        return array
      },

      xAxis () {
        let array = [], x = this.minX
        const incrementor = (this.maxX - this.minX)/ 7

        while( x < this.maxX ) {
          console.log(x)
          array.push({
            coord: this.normaliseX(x),
            labelText: Math.round(x/this.precision)*this.precision
          })

          x += incrementor
        }

        console.log(array)

        return array
      }
    },

    created () {
      this.minX = this.getMinValue('x')
      this.maxX = this.getMaxValue('x')
      this.maxY = this.getMaxValue('y')
    },

    methods: {
      getPath(dataset) {
        let path = ''
        
        dataset.forEach((point, index) => {
          let command = index == 0 ? 'M' : 'L'

          path += `${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
        })

        console.log('path', path)

        return path
      },

      getMaxValue (prop) {
        let maxArray = []

        this.lines.forEach(line => {
          maxArray.push(Math.max(...line.datapoints.map((t) => {
            return t[prop]
          })))
        }) 

        return Math.max(...maxArray)
      },

      getMinValue (prop) {
        let minArray = []

        this.lines.forEach(line => {
          minArray.push(Math.min(...line.datapoints.map((t) => {
            return t[prop]
          })))
        }) 

        return Math.min(...minArray)
      },

      normaliseX (value) {
        return (this.maxSvgX - ((value - this.minX) / (this.maxX - this.minX)) * this.maxSvgX) + this.offsetX
      },

      normaliseY (value) {
        return (this.maxSvgY- ((value - this.minY) / (this.maxY - this.minY)) * this.maxSvgY) + this.offsetY
      }
    }
  }
</script>