<template>
  <div class="accordion-item">
    <a class="accordion-item__title flex flex-h-between" @click="toggleAccordionContent()">
      <h3 class="heading--accordion">{{ title }}</h3>
      <i class="accordion-item__icon" :class="{ 'active': isActive }"></i>
    </a>
    
    <div class="accordion-item__content" :class="{ 'active': isActive }" @click="toggleAccordionContent()">
      <slot></slot>
    </div>
  </div>  
</template>

<script>
  import { eventHub } from '../../packs/application.js'

  export default {
    name: 'accordion-item',

    props: {
      id: {
        required: true,
        type: String
      },
      title: String,
      open: Boolean
    },

    data () {
      return {
        isActive: this.open
      }
    },

    methods: {
      toggleAccordionContent () {
        eventHub.$emit('calltoggleAccordionContent', this.id);
      }
    }
  }
</script>

<style lang="scss">
  .accordion-item {
    &__title {
      cursor: pointer;
    }

    &__content {
      cursor: pointer;
      max-height: 88px;
      overflow: hidden;

      transition: max-height .5s ease-in-out;

      &.active {
        max-height: 500px;
      }
    }
  }
</style>
