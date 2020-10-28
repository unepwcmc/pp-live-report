<template>
<div class="carousel--wipes">
  <!-- <div class="carousel__nav">
    <p
      v-for="(slide, index) in slides"
      :key="slide._uid"
      @click="scroll($event, `#chapter-${index + 1}`)"
    >
      Chapter {{ index + 1 }}
    </p>
  </div> -->

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
        <!-- <h2 class="carousel__title">{{ slide.title }}</h2>
        <p class="carousel__intro">{{ slide.intro}}</p>
        <a :href="slide.url" :title="'View chapter: #{slide.title}'" class="button--cta">View chapter</a> -->
      </div>
    </section>
  </div>
</div>
</template>

<script>
// import ScrollMagic from 'scrollmagic'
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
    // this.scrollMagicHandlers()
    this.scrollTriggerHandlers()
    // this.nav()
  },

  methods: {
    nav () {
      // init controller
      this.controller = new ScrollMagic.Controller()

      // build tween
      // const tween = gsap.from("#animate", 0.5, {autoAlpha: 0, scale: 0.7})

      // build scene
      // const scene = new ScrollMagic.Scene({triggerElement: "a#chapter-1", duration: 200,triggerHook: "onLeave"})
      //   .setTween(tween)
      //   .addTo(controller)

      // change behaviour of controller to animate scroll instead of jump
      this.controller.scrollTo(newpos => {
        gsap.to(window, 0.5, {scrollTo: {y: newpos}})
      })

    },

    scroll (e, id) {
      e.preventDefault()

      this.controller.scrollTo(id)
    },

    scrollTriggerHandlers () {
      let tl = gsap.timeline({
        scrollTrigger: {
          trigger: "#chapter-1", //trigger: ".container",
          pin: true,   // pin the trigger element while active
          pinSpacing:false,
          markers: true,
          start: "top top", // when the top of the trigger hits the top of the viewport
          end: "bottom top", // end after scrolling 500px beyond the start
          scrub: true, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
          // snap: {
          //   snapTo: "labels", // snap to the closest label in the timeline
          //   duration: {min: 0.2, max: 3}, // the snap animation should be at least 0.2 seconds, but no more than 3 seconds (determined by velocity)
          //   delay: 0.2, // wait 0.2 seconds from the last scroll event before doing the snapping
          //   ease: "power1.inOut" // the ease of the snap animation ("power3" by default)
          // }
        },
        x:400,
        rotation: 360,
        duration: 3,
      })

      // add animations and labels to the timeline
      // tl.addLabel("start")
      //   .from(".box p", {scale: 0.3, rotation:45, autoAlpha: 0})
      //   .addLabel("color")
      //   .from(".box", {backgroundColor: "#28a92b"})
      //   .addLabel("spin")
      //   .to(".box", {rotation: 360})
      //   .addLabel("end")

    },

    scrollMagicHandlers () {
      const controller = new ScrollMagic.Controller({
        globalSceneOptions: {
          duration: "200%" // this works just fine with duration 0 as well
          // However with large numbers (>20) of pinned sections display errors can occur so every section should be unpinned once it's covered by the next section.
          // Normally 100% would work for this, but here 200% is used, as Panel 3 is shown for more than 100% of scrollheight due to the pause.
        }
      })

      
      // var slides = this.$refs['animated-slide']
      // document.querySelectorAll("section.panel");

      // create scene for every slide
      for (var i=1; i<this.slides.length; i++) {
        const idSlide = `#chapter-${i}`
        const idSlideContent = `#chapter-${i} .carousel__content`

        console.log(idSlide)
        console.log(idSlideContent)
        
        new ScrollMagic.Scene({
          triggerElement: idSlide
        })
        .triggerHook('onLeave')
        .setPin(idSlide, {pushFollowers: false})
        .addTo(controller)

        new ScrollMagic.Scene({
          triggerElement: idSlideContent
        })
        .triggerHook('onEnter')
        .setClassToggle(idSlideContent, 'active')
        .addTo(controller)
      }
      
    } 
  }
}
</script>