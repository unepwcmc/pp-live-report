<template>
  <div class="references">
    <span class="references__link" @click="openModal">Explore references</span>
    <modal
      :text="references"
      type="references"
      :is-active="isActive"
      @close-modal="closeModal"
    ></modal>
  </div>
</template>

<script>
import Modal from '../modal/Modal'

export default {
  name: 'References',
  components: {
    Modal,
  },
  props: {
    referencesText: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      isActive: false
    }
  },
  methods: {
    openModal() {
      this.isActive = true
    },
    closeModal() {
      this.isActive = false
    },
  },
}
</script>