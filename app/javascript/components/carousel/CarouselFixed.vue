<template>
<div id="carousel" class="carousel">
  <div 
    :class="['carousel__nav', { 'active': isActive, 'end': atCarouselEnd }]">
    <p
      v-for="(slide, index) in slides"
      :key="slide._uid"
      @click="scroll(index + 1)"
      :class="['carousel__nav-item', { 'active': navItemActive(index + 1) }]"
    >
      <span class="carousel__nav-item-text">Chapter {{ index + 1 }}</span>
      <span :class="['carousel__nav-item-icon', { 'active': navItemActive(index + 1) }]" />
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
      atCarouselEnd: false,
      isActive: false,
      scrollTriggers: []
    }
  },

  mounted () {
    this.scrollTriggerHandlers()
    console.log('mounted', this.scrollTriggers)
  },

  beforeDestroy () {
    //Disable all scrollTriggers  
    this.scrollTriggers.forEach(trigger => {
      trigger.kill()
    })
    this.scrollTriggers = []
    console.log('kill triggers', this.scrollTriggers)
  },

  methods: {
    navItemActive (index) {
      return this.activeIndex == index
    },

    scroll (index) {
      //For some reason the .to doesn't work 
      //when scrolling back up so need to -1 off index
      const newIndex = index > this.activeIndex ? index : index - 1
      
      const slide = `#chapter-${newIndex}`

      gsap.to(window, { 
        duration: 1,
        overwrite: true,
        scrollTo: slide,
      })
    },

    scrollTriggerHandlers () {
      console.log('add')
      for (var i=1; i<=this.slides.length; i++) {
        const index = i,
              slideId = `#chapter-${i}`

        this.scrollTriggerHandlerContent(slideId, index)
        this.scrollTriggerHandlerNav(slideId, index)
        this.scrollTriggerHandlerNavItem(slideId, index)
        this.scrollTriggerHandlerPin(slideId, index)
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
      const here = ScrollTrigger.create({
        markers: true,
        animation: tl,
        start: "top 80%",
        trigger: id,
        onToggle: self => {
          self.isActive ? self.animation.play() : self.animation.pause(0)  
        },
      })
      
      this.scrollTriggers.push(ScrollTrigger)
    },

    scrollTriggerHandlerPin (id, index) {
      //Pin each slide
      const isLastSlide = index == this.slides.length

      ScrollTrigger.create({
        trigger: id,
        start: "top top",
        end: "+=100%",
        pin: !isLastSlide,
        pinSpacing: false,
        scrub: true,
        snap: 1,
      })

      this.scrollTriggers.push(ScrollTrigger)
    },
    
    scrollTriggerHandlerNav (){
      //Fix nav in place
      ScrollTrigger.create({
        trigger: '#carousel',
        start: "top top",
        end: "bottom bottom",
        onToggle: self => {
          this.isActive = self.isActive
          this.atCarouselEnd = self.progress == 1
        }
      })

      this.scrollTriggers.push(ScrollTrigger)
    },

    scrollTriggerHandlerNavItem (id, index){
      //Show active item in scroll to nav
      ScrollTrigger.create({
        trigger: id,
        start: "top 50%",
        end: "top -50%",
        onToggle: self => {
          if(self.isActive) { 
            this.activeIndex = index
          }
        }
      })

      this.scrollTriggers.push(ScrollTrigger)
    }
  }
}
</script>