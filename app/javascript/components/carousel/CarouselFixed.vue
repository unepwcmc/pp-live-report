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
    if(this.scrollTriggers.length == 0) {
      //create triggers on first load of homepage
      this.scrollTriggerHandlers()
    } else {
      //enable all triggers when navigating back 
      //to the homepage
      this.scrollTriggers.forEach(trigger => {
        trigger.enable()
      })
    }
  },

  beforeDestroy () {
    //disable all scrollTriggers  
    this.scrollTriggers.forEach(trigger => {
      trigger.disable()
    })
  },

  methods: {
    navItemActive (index) {
      return this.activeIndex == index
    },

    scroll (index) {
      //for some reason the .to doesn't work 
      //when scrolling back up so need to -1 off index
      const newIndex = index > this.activeIndex ? index : index - 1,
            slide = `#chapter-${newIndex}`

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
        this.scrollTriggerHandlerContent(slideId, index)
        this.scrollTriggerHandlerNav(slideId, index)
        this.scrollTriggerHandlerNavItem(slideId, index)
      }
    },

    scrollTriggerHandlerContent (id, index) {
      let tl = gsap.timeline()
      const content = [
        `#chapter-${index} .carousel__content`,
      ]

      tl.from(content, { 
        duration: .9, 
        ease: "sine.inOut", 
        opacity: 0, 
        stagger: 0.3 
      })
        
      //animate content of slide
      const trigger =  ScrollTrigger.create({
        animation: tl,
        start: "top 70%",
        trigger: id,
        onToggle: self => {
          self.isActive ? self.animation.play() : self.animation.pause(0)  
        },
      })
      
      this.scrollTriggers.push(trigger)
    },

    scrollTriggerHandlerPin (id, index) {
      //pin each slide
      const isLastSlide = index == this.slides.length

      const trigger = ScrollTrigger.create({
        trigger: id,
        start: "top top",
        end: "+=100%",
        pin: !isLastSlide,
        pinSpacing: false,
        scrub: true
      })

      this.scrollTriggers.push(trigger)
    },
    
    scrollTriggerHandlerNav (){
      //fix nav in place
      const trigger = ScrollTrigger.create({
        trigger: '#carousel',
        start: "top top",
        end: "bottom bottom",
        onToggle: self => {
          this.isActive = self.isActive
          this.atCarouselEnd = self.progress == 1
        }
      })

      this.scrollTriggers.push(trigger)
    },

    scrollTriggerHandlerNavItem (id, index){
      //show active item in scroll to nav
      const trigger = ScrollTrigger.create({
        trigger: id,
        start: "top 50%",
        end: "top -50%",
        onToggle: self => {
          if(self.isActive) { 
            this.activeIndex = index
          }
        }
      })

      this.scrollTriggers.push(trigger)
    }
  }
}
</script>