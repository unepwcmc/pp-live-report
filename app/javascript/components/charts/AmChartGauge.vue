<template>
  <div class="am-chart--pie">
    <div class="chart__chart">
      <div 
        class="chart__svg"
        :id="id"
      />
    </div>
  </div>
</template>

<script>
import * as am4core from "@amcharts/amcharts4/core"
import * as am4charts from "@amcharts/amcharts4/charts"
import am4themes_animated from "@amcharts/amcharts4/themes/animated"

export default {
  name: 'AmChartGauge',

  props: {
    id: {
      required: true,
      type: String
    },
    legendData: {
      type: Array // [{ name: String, fill: Strin }]
    },
    target: {
      type: Number
    },
    theme: {
      default: '#000',
      type: String,
    },
    value: {
      required: true,
      type: Number
    }
  },

  date () {
    return {
      axis: {},
      chart: {},
    }
  },

  mounted () {
    this.createChart()

    am4core.useTheme(am4themes_animated)

    setInterval(() => {
      var animation = new am4core.Animation(this.hand, {
        property: "value",
        to: this.value
      }, 1000, am4core.ease.cubicOut).start()
    }, 1000)
  },

  methods: {
    createChart () {
      this.chart = am4core.create(this.id, am4charts.GaugeChart)
      this.chart.innerRadius = 60

      this.createAxis()
      this.createRange()
      this.createHands()
      this.createLegend ()
    },

    createAxis () {
      this.axis = this.chart.xAxes.push(new am4charts.ValueAxis());
      this.axis.min = 0
      this.axis.max = 100
      this.axis.strictMinMax = true
      this.axis.renderer.line.strokeOpacity = 1
      this.axis.renderer.labels.template.opacity = 0
      this.axis.renderer.grid.template.disabled = true

      this.axisInner = this.chart.xAxes.push(new am4charts.ValueAxis());
      this.axisInner.min = 0
      this.axisInner.max = 100
      this.axisInner.renderer.radius = 60
      this.axisInner.strictMinMax = true
      this.axisInner.renderer.line .strokeOpacity = 1
      this.axisInner.renderer.labels.template.opacity = 0
      this.axisInner.renderer.ticks.opacity = 0
    },

    createRange () {
      let range = this.axis.axisRanges.create()
        range.value = 0
        range.endValue = this.value
        range.axisFill.fillOpacity = 1
        range.axisFill.fill = am4core.color(this.theme)
    },

    createHands () {
      if(this.target) {
        const handTarget = this.chart.hands.push(new am4charts.ClockHand())
        handTarget.value = this.target
        handTarget.startWidth = 1
        handTarget.stroke = am4core.color("#bcbcbc")
      }
      
      this.hand = this.chart.hands.push(new am4charts.ClockHand())
      this.hand.startWidth = 1
      this.hand.value = 0
    },

    createLegend () {
      this.legend = new am4charts.Legend();
      this.legend.isMeasured = false
      this.legend.y = am4core.percent(100)
      this.legend.verticalCenter = "bottom"
      this.legend.parent = this.chart.chartContainer
      this.legend.data = this.legendData.map((item) => {
        return { 
          "name": item.name,
          "fill": am4core.color(item.fill)  
        }
      })

      const markerTemplate = this.legend.markers.template
      markerTemplate.width = 20
      markerTemplate.height = 2
    }
  }
}
</script>