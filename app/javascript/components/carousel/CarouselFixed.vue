<template>
  <div class="carousel--fixed" :class="[{ 'animate': changingSlide }, `chapter-${this.activeIndex + 1}`]">
    <div class="carousel__slide">
      <div class="carousel__content" :class="{ 'animate': changingSlide }" ref="animated-slide">
        <p class="carousel__subtitle">{{ subtitle}}</p>
        <h2 class="heading--carousel carousel__title">{{ title }}</h2>
        <p class="carousel__intro">{{ intro}}</p>
        <a :href="url" :title="'View chapter: #{title}'" class="button--cta">View chapter</a>
      </div>
    </div>

    <div class="carousel__nav flex flex-column flex-v-end">
      <div v-for="slide, index in slides" class="carousel__nav-item flex" :class="{ 'active': isActive(index) }">
        <span class="carousel__nav-text">{{ slide.title }}</span>
        <button @click="changeSlide(index)" class="carousel__nav-button button--plain flex flex-center"> {{ index + 1 }}</button>
      </div>
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
        changingSlide: false,
        endEvent: ''
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

    mounted () {
      this.endEvent = this.getEndEvent()
    },

    methods: {
      changeSlide (index) {
        this.changingSlide = true

        this.$refs['animated-slide'].addEventListener(this.endEvent, () => {
          this.activeIndex = index
          this.changingSlide = false
        }, false)
      },

      isActive (index) {
        return this.activeIndex == index
      },

      getEndEvent () {
        const el = document.createElement("fakeelement")

        const animations = {
          'animation'      : 'animationend',
          'OAnimation'     : 'oAnimationEnd',
          'MozAnimation'   : 'animationend',
          'WebkitAnimation': 'webkitAnimationEnd'
        }

        for (let a in animations){
          if (el.style[a] !== undefined){
            return animations[a];
          }
        }
      }
    }
  }
</script>