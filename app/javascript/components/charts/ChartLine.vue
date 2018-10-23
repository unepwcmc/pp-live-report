<template>
  <div>
    <div v-if="lines" class="issues-chart__svg" style="width:100%;">
      <svg width="100%" height="100%" viewBox="-110 -30 1030 590" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">

        <rect 
          :x="-x.chartPadding/2"
          :y="-y.chartPadding/2" 
          :width="x.chartWidth + x.chartPadding" 
          :height="y.chartHeight + y.chartPadding" 
          fill="#EBEBEB" />

        <rect :x="normaliseX(2018)" y="0" width="120px" height="440" :fill="colours[3]" rx="4" ry="4" />
        
        <text v-for="y in yAxis" 
          :x="-x.chartPadding" 
          :y="y.coord"
          text-anchor="end">{{ y.labelText }}</text>

        <text v-for="x in xAxis" 
          :x="x.coord" 
          :y="y.chartHeight + y.chartPadding" 
          text-anchor="middle">{{ x.labelText }}</text>

        <chart-line-dataset 
          v-for="line, index in lines"
          :index="index"
          :path="getPath(line.datapoints)"
          :middle="getPathMiddle(line.datapoints)"
          :colour="colours[index]">
        </chart-line-dataset>

        <template v-if="targets">
          <chart-line-target v-for="target, index in targets"
            :minX="normaliseX(x.min)" 
            :maxX="normaliseX(x.max)" 
            :y="normaliseY(target.y)" 
            :title="target.title"
            :colour="targetColours[index]">
          </chart-line-target>
        </template>
      </svg>
    </div>

    <chart-legend v-if="legend" :rows="legend" :colours="colours"></chart-legend>
  </div>  
</template>

<script>
  import ChartLineDataset from './ChartLineDataset'
  import ChartLineTarget from './ChartLineTarget'
  import ChartLegend from './ChartLegend'

  export default {
    name: 'chart-line',

    components: { ChartLineTarget, ChartLineDataset, ChartLegend },

    props: {
      lines: {
        type: Array,
        required: true
      },
      targets: Array,
      legend: Array
    },

    data () {
      return {
        x: {
          precision: 1,
          chartWidth: 890,
          chartPadding: 50,
          min:0,
          max: 2022,
          axisMarks: 6
        },
        y: {
          precision: 1,
          chartHeight: 500,
          chartPadding: 50,
          min: 0,
          max: 0,
          axisMarks: 8
        },
        colours: ['#1D7DA6', '#03B0DA', '#71A32B', '#CCCBCB'],
        targetColours: ['rgba(29, 125, 166, 0.4)', 'rgba(113, 163, 43, 0.4)']
      }
    },

    computed: {
      yAxis () {
        return this.getAxis('y')
      },

      xAxis () {
        return this.getAxis('x')
      }
    },

    created () {
      this.x.min = this.getMinValue('x')
      // this.x.max = this.getMaxValue('x')
      this.y.max = this.getMaxValue('y')
    },

    methods: {
      getPath(dataset) {
        let path = ''
        
        dataset.forEach((point, index) => {
          let command = index == 0 ? 'M' : 'L'

          path += ` ${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
        })

        return path
      },

      getPathMiddle (dataset) {
        let middle = dataset[Math.floor(dataset.length/2)]

        return { x: this.normaliseX(middle.x), y: this.normaliseY(middle.y) }
      },

      getAxis (axis) {
        let array = [], n = this[axis].min
        const incrementor = (this[axis].max - this[axis].min)/ this[axis].axisMarks

        while( n < this[axis].max + incrementor) {
          array.push({
            coord: this[`normalise${axis.toUpperCase()}`](n),
            labelText: Math.ceil(n/this[axis].precision)*this[axis].precision
          })

          n += incrementor
        }

        return array
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
        return (((value - this.x.min) / (this.x.max - this.x.min)) * this.x.chartWidth)
      },

      normaliseY (value) {
        return (this.y.chartHeight- ((value - this.y.min) / (this.y.max - this.y.min)) * this.y.chartHeight)
      }
    }
  }
</script>