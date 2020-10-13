<template>
  <div class="download__popup">
    <ul class="ul-unstyled">
      <li 
        v-for="option in options"
        :key="option._uid"
      >
        <a
          class="download__link"
          :href="option.url"
          target="_blank"
          :title="option.title"
          v-html="option.title"
        />
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'DownloadPopup',
  props: {
    options: Array
  },
  methods: {
    clickOption(option) {
      this.$emit('downloadStarted', option)
    }
  }
}
</script>