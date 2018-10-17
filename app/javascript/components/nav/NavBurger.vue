<template>
  <div class="nav--burger" :class="classes">
    <button class="nav__trigger icon--burger" @click="toggle">NAV</button>
    
    <div class="nav__target" :class="{ 'active': isActive }">
      <button class="nav__close icon--close" @click="toggle">X</button>
      <ul class="nav__ul ul-unstyled">
        <slot></slot>
      </ul>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'nav-burger',

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
