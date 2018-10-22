<template>
  <div>
    <div v-if="lines">
      <div class="issues-chart__svg" style="width:100%;">
        <svg width="100%" height="100%" viewBox="-110 0 1000 550" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">

          <rect x="0" y="0" width="890" height="500" fill="#EBEBEB" />
          <rect x="0" y="0" width="120px" height="440" fill="#CCCBCB" rx="4" ry="4" />

          <path v-for="line, index in lines" :d="getPath(line.datapoints)" fill="none" :stroke="colors[index]" stroke-width="6" />
          
          <text v-for="y in yAxis" :x="-10" :y="y.coord" text-anchor="end">{{ y.labelText }}</text>
          <text v-for="x in xAxis" :x="x.coord" :y="maxSvgY + 30" text-anchor="middle">{{ x.labelText }}</text>

          <circle cx="0" cy="0" fill="red" r="2"></circle>
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
        x: {
          precision: 1,
        },
        colors: ['#1D7DA6', '#03B0DA', '#71A32B'],
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
            labelText: Math.round(x/this.x.precision)*this.x.precision
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
        return (this.maxSvgX - ((value - this.minX) / (this.maxX - this.minX)) * this.maxSvgX)
      },

      normaliseY (value) {
        return (this.maxSvgY- ((value - this.minY) / (this.maxY - this.minY)) * this.maxSvgY)
      }
    }
  }
</script>