export default {
  created () {
    window.addEventListener('scroll', this.slideOutOnScroll('.pagination', '-74px'));
  },
  destroyed () {
    window.removeEventListener('scroll', this.slideOutOnScroll('.pagination', '-74px'));
  },
  methods: {
    slideOutOnScroll(className, offset) {
      if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        document.querySelector(className).style.bottom = "0";
      } else {
        document.querySelector(className).style.bottom = `${offset}`;
      }
    }
  }
}