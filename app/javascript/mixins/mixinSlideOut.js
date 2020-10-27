export default ({scrollPoint = 150, className, offset}) => ({
  created() {
    window.addEventListener('scroll', this.slideOutOnScroll);
  },
  destroyed() {
    window.removeEventListener('scroll', this.slideOutOnScroll);
  },
  methods: {
    slideOutOnScroll() {
      if (document.body.scrollTop > scrollPoint || document.documentElement.scrollTop > scrollPoint) {
        document.querySelector(className).style.bottom = "0";
      } else {
        document.querySelector(className).style.bottom = `${offset}`;
      }
    }
  }
})