<template>
  <div class="carousel--fixed">
    <div class="carousel__nav flex flex-column flex-v-end">
      <button v-for="slide, index in slides" @click="changeSlide(index)" class="carousel__nav-item">{{ slide.title }}</button>
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
        index: 0,
      }
    },

    computed: {
      title () {
        return this.slides[this.index]['title']
      },

      subtitle () {
        return this.slides[this.index]['subtitle']
      },

      intro () {
        return this.slides[this.index]['intro']
      },

      url () {
        return this.slides[this.index]['url']
      }
    },

    methods: {
      changeSlide (index) {
        this.index = index
      }
    }
  }
</script>