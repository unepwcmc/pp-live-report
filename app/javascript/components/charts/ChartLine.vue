<template>
  <div>
    <div v-if="lines">
      <div class="issues-chart__svg" style="width:100%;">
        <svg width="100%" height="100%" viewBox="-110 0 1030 570" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">

          <rect 
            :x="-x.chartPadding/2"
            :y="-y.chartPadding/2" 
            :width="x.chartWidth + x.chartPadding" 
            :height="y.chartHeight + y.chartPadding" 
            fill="#EBEBEB" />

          <rect :x="normaliseX(2018)" y="0" width="120px" height="440" fill="#CCCBCB" rx="4" ry="4" />
          
          <path v-for="line, index in lines" 
            :d="getPath(line.datapoints)" 
            fill="none" 
            :stroke="colors[index]" 
            stroke-width="6" />
          
          <text v-for="y in yAxis" 
            :x="-x.chartPadding" 
            :y="y.coord" 
            text-anchor="end">{{ y.labelText }}</text>

          <text v-for="x in xAxis" 
            :x="x.coord" 
            :y="y.chartHeight + y.chartPadding" 
            text-anchor="middle">{{ x.labelText }}</text>

          <!-- <circle cx="0" cy="0" fill="red" r="2"></circle> -->

          <chart-line-target :minX="normaliseX(this.minX)" :maxX="normaliseX(this.maxX)" :y="normaliseY(40)" title="Marine target (17%)"></chart-line-target>
          <chart-line-target :minX="normaliseX(this.minX)" :maxX="normaliseX(this.maxX)" :y="normaliseY(33)" title="Terrestrial target (10%)"></chart-line-target>
        </svg>
      </div>
    </div>
  </div>  
</template>

<script>
  import ChartLineTarget from './ChartLineTarget'

  export default {
    name: 'chart-line',

    components: { ChartLineTarget },

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
          chartWidth: 890,
          chartPadding: 50
        },
        y: {
          precision: 1,
          chartHeight: 500,
          chartPadding: 50
        },
        colors: ['#1D7DA6', '#03B0DA', '#71A32B'],
        offsetX: 220,
        offsetY: 0,
        minX: 0,
        maxX: 2022,
        minY: 0,
        maxY: 0
      }
    },

    computed: {
      yAxis () {
        let array = [], y = 0
        const incrementor = (this.maxY - this.minY) / 8

        while( y < this.maxY + incrementor) {
          array.push({
            coord: this.normaliseY(y),
            labelText: Math.round(y/this.y.precision)*this.y.precision
          })

          y += incrementor
        }

        console.log(array)

        return array
      },

      xAxis () {
        let array = [], x = this.minX
        const incrementor = (this.maxX - this.minX)/ 6

        while( x < this.maxX + incrementor) {
          console.log(x)
          array.push({
            coord: this.normaliseX(x),
            labelText: Math.ceil(x/this.x.precision)*this.x.precision
          })

          x += incrementor
        }

        console.log(array)

        return array
      }
    },

    created () {
      this.minX = this.getMinValue('x')
      // this.maxX = this.getMaxValue('x')
      this.maxY = this.getMaxValue('y')
    },

    methods: {
      getPath(dataset) {
        let path = ''
        
        dataset.forEach((point, index) => {
          let command = index == 0 ? 'M' : 'L'

          path += ` ${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
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
        return (((value - this.minX) / (this.maxX - this.minX)) * this.x.chartWidth)
      },

      normaliseY (value) {
        return (this.y.chartHeight- ((value - this.minY) / (this.maxY - this.minY)) * this.y.chartHeight)
      }
    }
  }
</script>