<template>
  <div class="nav--burger" :class="classes">
    <span class="nav__trigger" @click="toggle"></span>
    
    <div class="nav__target" :class="{ 'active': isActive }">
      <span class="nav__close icon--close" @click="toggle"></span>
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
