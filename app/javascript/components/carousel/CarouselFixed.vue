<template>
  <div class="carousel--fixed">
    <div class="carousel__nav flex flex-column flex-v-end">
      <div v-for="slide, index in slides" class="carousel__nav-item flex" :class="{ 'active': isActive(index) }">
        <span class="carousel__nav-text">{{ slide.title }}</span>
        <button @click="changeSlide(index)" class="carousel__nav-button button--plain flex flex-center"> {{ index + 1 }}</button>
      </div>
    </div>

    <div class="carousel__slide">
      <p>{{ subtitle}}</p>
      <h2 class="carousel__title">{{ title }}</h2>
      <p class="carousel__intro">{{ intro}}</p>
      <a :href="url" :title="'View chapter: #{title}'" class="button--cta">View chapter</a>
    </div>
  </div>  
</template>

<script>
  export default {
    name: 'carousel-fixed',

    props: {
      slides: {
        type: Array,
        required: true
      }
    },

    data () {
      return {
        activeIndex: 0,
      }
    },

    computed: {
      title () {
        return this.slides[this.activeIndex]['title']
      },

      subtitle () {
        return this.slides[this.activeIndex]['subtitle']
      },

      intro () {
        return this.slides[this.activeIndex]['intro']
      },

      url () {
        return this.slides[this.activeIndex]['url']
      }
    },

    methods: {
      changeSlide (index) {
        this.activeIndex = index
      },

      isActive (index) {
        return this.activeIndex == index
      }
    }
  }
</script>