<template>
  <div class="chart--doughnut">
    <svg width="100%" height="100%" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
      <path d="M 50 50 l 0 20 A 30 30 0 0 0 80 40 l -20 0 A 10 10 0 0 1 50 50 Z" fill="#565656" stroke="#ff0000"/>
      
      <g transform="rotate(90)" transform-origin="50 40">
        <path d="M 50 50 l 0 20 A 30 30 0 0 0 80 40 l -20 0 A 10 10 0 0 1 50 50 Z" stroke="#00ff00" />
      </g>

      <g transform="rotate(180)" transform-origin="50 40">
        <path d="M 50 50 l 0 20 A 30 30 0 0 0 80 40 l -20 0 A 10 10 0 0 1 50 50 Z" stroke="#00ff00" />
      </g>

      <g transform="rotate(270)" transform-origin="50 40">
        <path d="M 50 50 l 0 20 A 30 30 0 0 0 80 40 l -20 0 A 10 10 0 0 1 50 50 Z" stroke="#00ff00" />
      </g>
    </svg>
  </div>  
</template>

<script>
  export default {
    name: 'chart-doughnut',

    props: {
      dataset: {
        type: Array,
        required: true
      }
    }
  }  
</script>