<template>
  <div class="chart--row-stacked">
    <h3 v-if="title" class="chart__title">{{ title }}</h3>

    <div class="chart__chart flex">
      <p v-for="row in rows" class="chart__bar flex flex-v-center" :style="{ width: row.percent + '%' }">
        <span><strong>{{ row.label }}</strong> {{ row.percent}}%</span>
      </p>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'chart-row-stacked',

    props: {
      title: String,
      rows: {
        type: Array,
        required: true
      }
    }
  }
</script>