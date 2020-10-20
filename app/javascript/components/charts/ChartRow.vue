<template>
 <div class="chart--row">
  <p v-if="title" class="chart__title">{{ title }}</p>

  <div class="chart__chart">
   <div
    v-for="(row, index) in rows"
    :key="`row-${index}`"
    class="chart__row flex flex-v-center flex-h-between"
    :class="themeClass"
   >
    <span class="chart__bar" :style="{ width: row.percent + '%' }"></span>
    <span class="chart__percent">{{ row.percent }}%</span>
    <span class="chart__label">{{ row.label }}</span>
   </div>
  </div>
  <ul class="chart__legend">
   <li>
    <span :class="`chart-key__oecm--${legendClass}`"></span>
    <p>OECMs {{ oecmPercent }}%</p>
   </li>
   <li>
    <span :class="`chart-key__wdpa--${legendClass}`"></span>
    <p>WDPAs {{ wdpaPercent }}%</p>
   </li>
  </ul>
 </div>
</template>

<script>
export default {
 name: "chart-row",

 props: {
  oecmPercent: {
   type: Number,
   default: 0,
  },
  title: String,
  theme: String,
  rows: {
   type: Array,
   required: true,
  },
  wdpaPercent: {
   type: Number,
   default: 0,
  },
 },

 computed: {
  themeClass() {
   return `chart-theme--${this.theme}`;
  },
  legendClass() {
    return `${this.theme}`;
  }
 },
};
</script>