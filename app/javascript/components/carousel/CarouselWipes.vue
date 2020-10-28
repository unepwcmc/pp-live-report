<template>
<div class="carousel">
  <div class="carousel__nav">
    <p
      v-for="(slide, index) in slides"
      :key="slide._uid"
      @click="scroll($event, `#chapter-${index + 1}`)"
    >
      Chapter {{ index + 1 }}
    </p>
  </div>

  <div class="carousel__slides">
    <section 
      v-for="(slide, index) in slides"
      :key="slide._uid"
      :id="`chapter-${index + 1}`" 
      class="carousel__slide"
      ref="animated-slide"
    >
      <div 
        :class="['carousel__content container', { 'animate': changingSlide }]">
        <p class="carousel__subtitle">{{ slide.subtitle}}</p>
        <h2 class="carousel__title">{{ slide.title }}</h2>
        <p class="carousel__intro">{{ slide.intro}}</p>
        <a :href="slide.url" :title="'View chapter: #{slide.title}'" class="button--cta">View chapter</a>
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
  name: 'carousel-wipes',

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

  mounted () {
    this.scrollTriggerHandlers()
  },

  methods: {
    scrollTriggerHandlers () {
      // gsap.utils.toArray(".carousel__slide").forEach((slide, i) => {
      for (var i=1; i<this.slides.length; i++) {
        const idSlide = `#chapter-${i}`
        const idSlideContent = `#chapter-${i} .carousel__content`

        ScrollTrigger.create({
          markers: true,
          trigger: idSlide,
          start: "top top",
          end: () => "+=" + document.querySelector(".carousel").offsetWidth,
          pin: true,
          pinSpacing: false,
          // snap: 1 / (this.slides.length - 1),
          // scrub: true
        })

        let tl = gsap.timeline({
          
        })
        

        tl.from(idSlideContent, { opacity: 0, })

        ScrollTrigger.create({
          
          markers: true,
          animation: tl,
          trigger: idSlide,
          start: "top 80%",
          end: () => "+=" + document.querySelector(".carousel").offsetWidth,
          scrub: true
        })
      }

      // let tl = gsap.timeline({
      //   scrollTrigger: {
      //     trigger: "#chapter-1", //trigger: ".container",
      //     pin: true,   // pin the trigger element while active
      //     pinSpacing:false,
      //     markers: true,
      //     start: "top top", // when the top of the trigger hits the top of the viewport
      //     end: "+=300px", // end after scrolling 500px beyond the start
      //     // scrub: true, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
      //     // snap: {
      //     //   snapTo: "labels", // snap to the closest label in the timeline
      //     //   duration: {min: 0.2, max: 3}, // the snap animation should be at least 0.2 seconds, but no more than 3 seconds (determined by velocity)
      //     //   delay: 0.2, // wait 0.2 seconds from the last scroll event before doing the snapping
      //     //   ease: "power1.inOut" // the ease of the snap animation ("power3" by default)
      //     // }
      //   }
      // })

      // add animations and labels to the timeline
      // tl.addLabel("start")
      //   .from(".box p", {scale: 0.3, rotation:45, autoAlpha: 0})
      //   .addLabel("color")
      //   .from(".box", {backgroundColor: "#28a92b"})
      //   .addLabel("spin")
      //   .to(".box", {rotation: 360})
      //   .addLabel("end")

    }
  }
}
</script>