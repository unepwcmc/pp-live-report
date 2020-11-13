<template>
<div class="carousel">
  <div class="carousel__nav">
    <p
      v-for="(slide, index) in slides"
      :key="slide._uid"
      @click="scroll(index + 1)"
      :class="['carousel__nav-item', { 'active': isActive(index + 1) }]"
    >
      <span class="carousel__nav-item-text">Chapter {{ index + 1 }}</span>
      <span :class="['carousel__nav-item-icon', { 'active': isActive(index + 1) }]" />
    </p>
  </div>

  <div 
    class="carousel__slides"
    id="chapter-0" 
  >
    <section 
      v-for="(slide, index) in slides"
      :key="slide._uid"
      :id="`chapter-${index + 1}`" 
      class="carousel__slide"
      ref="animated-slide"
    >
      <div class="carousel__content container">
        <p class="carousel__subtitle">{{ slide.subtitle}}</p>
        <h2 class="carousel__title">{{ slide.title }}</h2>
        <p class="carousel__intro">{{ slide.intro}}</p>
        <a :href="slide.url" :title="'View chapter: #{slide.title}'" class="carousel__button button--cta">View chapter</a>
      </div>
    </section>
  </div>
</div>
</template>

<script>
import { ScrollToPlugin } from "gsap/ScrollToPlugin"
import { ScrollTrigger } from "gsap/ScrollTrigger"
import { gsap } from "gsap"

gsap.registerPlugin(ScrollToPlugin, ScrollTrigger)

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
      endEvent: '',
    }
  },

  mounted () {
    this.scrollTriggerHandlers()
  },

  methods: {
    isActive (index) {
      return this.activeIndex == index
    },

    scroll (index) {
      //For some reason the .to doesn't work 
      //when going back up so need to -1 off index
      this.activeIndex = index > this.activeIndex ? index : index - 1
      
      const slide = `#chapter-${this.activeIndex}`

      gsap.to(window, { 
        duration: 1,
        overwrite: true,
        scrollTo: slide,
      })
    },

    scrollTriggerHandlers () {
      for (var i=1; i<=this.slides.length; i++) {
        const index = i,
              slideId = `#chapter-${i}`

        this.scrollTriggerHandlerPin(slideId, index)
        this.scrollTriggerHandlerNav(slideId, index)
        this.scrollTriggerHandlerContent(slideId, index)
      }
    },

    scrollTriggerHandlerContent (id, index) {
      let tl = gsap.timeline()
      const content = [
        `#chapter-${index} .carousel__subtitle`,
        `#chapter-${index} .carousel__title`,
        `#chapter-${index} .carousel__intro`,
        `#chapter-${index} .carousel__button`
      ]

      tl.from(content, { 
        duration: .9, 
        ease: "sine.inOut", 
        opacity: 0, 
        stagger: 0.3 
      })
        
      //Animate content of slide
      ScrollTrigger.create({
        animation: tl,
        start: "top 80%",
        trigger: id,
        onToggle: self => {
          self.isActive ? self.animation.play() : self.animation.pause(0)  
        },
      })
    },

    scrollTriggerHandlerPin (id, index) {
      //Pin each slide
      if(index == this.slides.length) { 
        
        const trigger = ScrollTrigger.create({
          trigger: id,
          start: "top top",
          end: "+=100%",
          pin: false,
          pinSpacing: false,
          scrub: true,
          snap: 1,
        })

        return false
      }
      const trigger = ScrollTrigger.create({
        trigger: id,
        start: "top top",
        end: "+=100%",
        pin: true,
        pinSpacing: false,
        scrub: true,
        snap: 1,
      })
    },
    
    scrollTriggerHandlerNav (id, index){
      //Show active item in scroll to nav
      ScrollTrigger.create({
        trigger: id,
        start: "top 50%",
        end: "top -50%",
        onToggle: self => {
          if(self.isActive) { this.activeIndex = index }
        }
      })
    }
  }
}
</script>