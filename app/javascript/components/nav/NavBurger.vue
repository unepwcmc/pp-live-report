<template>
  <div :class="classes">
    <button class="button nav__burger icon--burger" @click="toggleNavPane">NAV</button>
    
    <div class="nav__pane" :class="{ 'active': isActive }">
      <button class="button nav__close icon--close" @click="toggleNavPane">X</button>
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
      toggleNavPane () {
        this.isActive = !this.isActive
      }
    }
  }  
</script>
