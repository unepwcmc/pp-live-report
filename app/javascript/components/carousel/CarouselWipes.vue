<template>
<div>
  <div class="nav">
    <a href="#chapter-1" @click="scroll($event, '#chapter-1')">1</a>
    <a href="#chapter-2" @click="scroll($event, '#chapter-2')">2</a>
    <a href="#chapter-3" @click="scroll($event, '#chapter-3')">3</a>
    <a href="#chapter-4" @click="scroll($event, '#chapter-4')">4</a>
  </div>

  <div>
    <section 
      v-for="slide in slides"
      :key="slide._uid"
      id="chapter-1" 
      class="panel blue"
    >
      <div 
        :class="['carousel__content', { 'animate': changingSlide }]" ref="animated-slide">
        <p class="carousel__subtitle">{{ slide.subtitle}}</p>
        <h2 class="heading--carousel carousel__title">{{ slide.title }}</h2>
        <p class="carousel__intro">{{ slide.intro}}</p>
        <a :href="url" :title="'View chapter: #{slide.title}'" class="button--cta">View chapter</a>
      </div>
    </section>
  </div>
</div>
</template>

<script>
import ScrollMagic from 'scrollmagic'
import { ScrollToPlugin } from "gsap/ScrollToPlugin"
import { gsap } from "gsap"

gsap.registerPlugin(ScrollToPlugin)

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
    this.scrollMagicHandlers()
    this.nav()
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
      this.controller.scrollTo(function (newpos) {
        gsap.to(window, 0.5, {scrollTo: {y: newpos}})
      })

    },

    scroll (e, id) {
      e.preventDefault()

      this.controller.scrollTo(id)
    },

    scrollMagicHandlers () {
      const controller = new ScrollMagic.Controller({
        globalSceneOptions: {
          triggerHook: 'onLeave',
          duration: "200%" // this works just fine with duration 0 as well
          // However with large numbers (>20) of pinned sections display errors can occur so every section should be unpinned once it's covered by the next section.
          // Normally 100% would work for this, but here 200% is used, as Panel 3 is shown for more than 100% of scrollheight due to the pause.
        }
      })

      var slides = document.querySelectorAll("section.panel");

      // create scene for every slide
      for (var i=0; i<slides.length; i++) {
        new ScrollMagic.Scene({
          triggerElement: slides[i]
        })
        .setPin(slides[i], {pushFollowers: false})
        .addTo(controller);
      }
    } 
  }
}
</script>