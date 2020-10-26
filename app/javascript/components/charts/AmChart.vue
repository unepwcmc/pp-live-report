<template>
 <div class="chart--amchart">
  <div class="chart--amchart__wrapper-ie11">
   <div class="chart--amchart__scrollable">
    <div class="chart--amchart__bounding-box">
     <div class="chart--amchart__svg" id="chartdiv" />
    </div>
   </div>
  </div>
 </div>
</template>

<script>
import * as am4core from "@amcharts/amcharts4/core";
import * as am4charts from "@amcharts/amcharts4/charts";
import am4themes_animated from "@amcharts/amcharts4/themes/animated";

am4core.useTheme(am4themes_animated);

const STROKE_COLOUR = am4core.color("#c8c8c8");

export default {
 name: "AmChart",
 mounted() {
  this.chartInit();
 },
 props: {
  chartBackgroundColour: {
   default: "#ffffff",
   type: String,
  },
  rawData: {
   type: Object,
   required: true,
  },
  dots: {
   type: Boolean,
   default: true,
  },
 },
 data() {
  return {
   chart: null,
   colours: ["#64BAD9", "#A54897", "#65C9B2"], // see $theme-chart in settings.scss
   totalSeries: 0,
   xAxis: null,
   yAxis: null,
  };
 },
 methods: {
  chartInit() {
   this.totalSeries = Object.keys(this.rawData.datapoints[0]).length - 1;

   this.createChart();
   this.createXAxis();
   this.createYAxis();
   this.createSeries();
   this.createLegend();
  },

  createXAxis() {
   this.xAxis = this.chart.xAxes.push(new am4charts.DateAxis());
   this.styleAxisLine(this.xAxis);

   this.xAxis.renderer.minGridDistance = 50;
   this.xAxis.renderer.ticks.template.disabled = false;
   this.xAxis.renderer.ticks.template.strokeOpacity = 1;
   this.xAxis.renderer.ticks.template.stroke = STROKE_COLOUR;
   this.xAxis.renderer.ticks.template.length = 6;
  },

  createYAxis() {
    this.yAxis = this.chart.yAxes.push(new am4charts.ValueAxis());
    this.yAxis.title.maxWidth = 120;
    this.yAxis.title.text = `[bold]${this.rawData.units}[/]`;
    this.yAxis.title.rotation = 0;
    this.yAxis.title.valign = "top";
    this.yAxis.title.wrap = "true";
    this.yAxis.marginLeft = 0;
    this.yAxis.maxWidth = 190; 
    this.yAxis.title.dy = -65;
    this.yAxis.title.dx = 70;

    this.styleAxisLine(this.yAxis);
  },

  styleAxisLine(axis) {
    axis.renderer.grid.template.disabled = true;
    axis.renderer.line.strokeOpacity = 1;
    axis.renderer.line.strokeWidth = 1;
    axis.renderer.line.stroke = STROKE_COLOUR;
  },

  createChart() {
   am4core.options.autoSetClassName = true;

   this.chart = am4core.create("chartdiv", am4charts.XYChart);
   this.chart.data = this.rawData.datapoints;
   this.chart.paddingTop = 70;
   this.chart.paddingRight = 40;
   this.chart.paddingLeft = -20;
   this.chart.background.fill = this.chartBackgroundColour;
  },

  createDots(series, i) {
   const bullet = series.bullets.push(new am4charts.CircleBullet());
   bullet.fill = am4core.color(this.colours[i]);
  },

  createLegend() {
   const legend = (this.chart.legend = new am4charts.Legend());
   legend.maxWidth = undefined;
  },

  createSeries() {
   for (let i = 0; i < this.totalSeries; i++) {
    const series = this.chart.series.push(new am4charts.LineSeries());
    series.dataFields.valueY = i + 1;
    series.dataFields.dateX = "x";
    series.name = this.rawData.legend[i];
    series.stroke = am4core.color(this.colours[i]);
    series.strokeWidth = 3;
    series.yAxis = this.yAxis;
    
    // Animation durations - can be tweaked
    series.hiddenState.transitionDuration = 500;
    series.interpolationDuration = 500;
    series.sequencedInterpolation = false;

    if (this.dots) {
     this.createDots(series, i);
    }
   }
  },
 },
};
</script>