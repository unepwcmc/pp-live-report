<template>
  <div class="social--share" :class="classes">
    <span class="social--share social__trigger icon--share" @click="toggle"></span>
    
    <div class="social__target" :class="{ 'active': isActive }">
      <slot></slot>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'social-share',

    props: {
      classes: String
    },

    data () {
      return {
        isActive: false
      }
    },

    methods: {
      toggle () {
        this.isActive = !this.isActive
      }
    }
  }
</script>