<template>
  <div class="carousel--fixed">
    <div class="carousel__nav">
      <button v-for="slide, index in slides" @click="changeSlide(index)">{{ slide.title }}</button>
    </div>

    <div class="carousel__slide">
      <p>{{ subtitle}}</p>
      <h2>{{ title }}</h2>
      <p>{{ intro}}</p>
      <a :href="url" :title="'View chapter: #{title}'">View chapter</a>
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