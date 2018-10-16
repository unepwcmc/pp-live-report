<template>
  <div :class="classes">
    <button class="button nav__burger icon--burger" @click="toggleNavPane">NAV</button>

    <ul class="nav__pane ul-unstyled" :class="{ 'nav__pane--active': isActive }">
      <button class="button nav__close icon--close" @click="toggleNavPane">X</button>
      <slot></slot>
    </ul>
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
