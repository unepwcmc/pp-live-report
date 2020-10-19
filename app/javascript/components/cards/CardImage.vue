<template>
  <a href="#" :title="`View the case study: ${caseStudy.title}`" class="card--case-study" @click="openModal">
    <div class="card__image"></div>
      <div class="card__overlay">
        <h2 class="card__title">{{ caseStudy.title }}</h2>
        <p class="card__summary">{{ caseStudy.text }}</p>
        <i class="icon--circle-chevron-white"></i>
      </div>
  </a>
</template>

<script>
  export default {
    name: 'CardImage',
    props: {
      caseStudy: {
        type: Object,
        required: true
      },
    },
    methods: {
      openModal() {
        
      }
    },
  }
</script>