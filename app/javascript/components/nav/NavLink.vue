<template>
  <li class="nav__li" :class="[{ 'active': currentPage }, classes]">
    <a :href="href" class="nav__a" :class="[iconClass]">
      <p class="nav__text">
        <span class="nav__subtitle">{{ subtitle }}</span>
        <span class="nav__title">{{ title }}</span>
      </p>
      <slot></slot>
    </a>
  </li>
</template>

<script>
  export default {
    name: 'nav-link',

    props: {
      href: { 
        type: String,
        required: true 
      },
      title: { 
        type: String,
        required: true 
      },
      subtitle: String,
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
