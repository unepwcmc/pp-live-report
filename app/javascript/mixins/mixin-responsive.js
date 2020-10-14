export default {
  data () {
    return {
      windowWidth: 0,
      currentBreakpoint: '',
      breakpoints: {
        small: 720, // MUST MATCH VARIABLES IN assets/stylesheets/utilities/_variables
        medium: 960,
        large: 1200
      }
    }
  },

  created () {
    this.updateWindowSize()

    // allow for multiple functions to be called on window resize
    window.addEventListener('resize', () => this.$root.$emit('windowResized'))

    this.$root.$on('windowResized', this.updateWindowSize)
  },

  methods: {
    updateWindowSize () {
      this.windowWidth = window.innerWidth

      if(this.isSmall()) { this.currentBreakpoint = 'small' }
      if(this.isMedium()) { this.currentBreakpoint = 'medium' }
      if(this.isLarge()) { this.currentBreakpoint = 'large' }
      if(this.isXLarge()) { this.currentBreakpoint = 'xlarge' }
    },

    isSmall () {
      return this.windowWidth <= this.breakpoints.small
    },

    isMedium () {
      return this.windowWidth > this.breakpoints.small && this.windowWidth <= this.breakpoints.medium
    },

    isLarge () {
      return this.windowWidth > this.breakpoints.medium && this.windowWidth <= this.breakpoints.large
    },

    isXLarge () {
      return this.windowWidth > this.breakpoints.large
    },

    getCurrentBreakpoint () {
      return this.currentBreakpoint
    }
  }
}
