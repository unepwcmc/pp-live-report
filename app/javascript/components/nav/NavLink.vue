<template>
  <li class="nav__li" :class="classes">
    <a :href="href" class="nav__a" :class="[{ 'nav--active': currentPage }, iconClass]">{{ text }}</a>
  </li>
</template>

<script>
  export default {
    name: 'nav-link',

    props: {
      href: { required: true },
      text: { required: true },
      icon: String,
      currentPage: Boolean,
      classes: String
    },

    computed: {
      iconClass () {
        return 'icon--' + this.icon
      }
    }
  }  
</script>
