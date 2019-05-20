<template>
  <div class="chart--column">
    <div class="chart__chart flex flex-h-between">
      <div v-for="column, index in columns" class="chart__column flex flex-column flex-h-end" :style="{ width: width }">
        <span class="chart__percent flex-vs-center">{{ getColumnValue(column) }}</span>
        <span class="chart__bar" :style="{ height: getColumnHeight(column) + '%' }"></span> 

        <p class="chart__label">
          <span class="fw-black">{{ column.label }}</span>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'chart-column',

    props: {
      title: String,
      columns: {
        type: Array,
        required: true
      },
      units: {
        type: String,
        default: ''
      },
      formatValues: {
        type: Boolean,
        default: true
      },
      maxValue: {
        type: Number,
        default: 0
      }
    },

    data () {
      return {
        maxColumnValue: 0
      }
    },

    computed: {
      width () {
        const total = this.columns.length
        return (100/total) - 3 + '%'
      }
    },

    created () {
      this.setMaxColumnHeight()
    },

    methods: {
      getColumnHeight (column) {
        return 90 * column.value / this.maxColumnValue
      },

      getColumnValue (column) {
        const formattedValue = this.formatValues ? column.value.toLocaleString() : column.value

        return formattedValue + this.units
      },

      setMaxColumnHeight () {
        if (this.maxValue) {
          this.maxColumnValue = this.maxValue
        }
        
        this.columns.forEach(col => {
          if (col.value > this.maxColumnValue) {
            this.maxColumnValue = col.value
          }
        })
      }
    }
  }
</script>