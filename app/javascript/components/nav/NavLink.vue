<template>
  <li class="nav__li" :class="[{ 'active': currentPage }, classes]">
    <a :href="href" class="nav__a" :class="[iconClass]">
      <span class="nav__text">{{ text }}</span>
      <span class="nav__title">{{ title }}</span>
      <slot></slot>
    </a>
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
