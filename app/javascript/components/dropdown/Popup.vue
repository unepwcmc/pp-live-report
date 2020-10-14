<template>
  <div :class="classes">
    <ul class="ul-unstyled">
      <li 
        v-for="option in options"
        :key="option._uid"
      >
        <a
          :class="[ option.hasOwnProperty('customClass') ? option.customClass : 'download__link']"
          :href="option.url"
          target="_blank"
          :title="option.title"
          :v-html="{ showText: option.title }"
        />
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'Popup',
    props: {
      classes: String,
      showText: {
        type: Boolean,
        required: true
      },
      options: {
        type: Array,
        default: () => ([
          { url: 'www.google.com', title: 'test' },
          { url: 'en.wikipedia.org', title: 'test2' }
        ])
      }
    },
    methods: {
    clickOption(option) {
      this.$emit('optionSelected', option)
    }
  }
  }
</script>

