<template>
  <div :class="[isActive ? 'modal-wrapper--active' : 'modal-wrapper']">
    <div
      v-if="isActive && type === 'caseStudy'"
      class="modal__window--case-study"
    >
      <button class="modal__close icon--cross" @click.stop="modalClose" />
      <div class="modal__content--case-study">
        <p v-if="text.report" class="modal__report">{{ text.report }}</p>
        <h2 class="modal__title">{{ text.title }}</h2>
        <p v-if="text.authors" class="modal__authors">{{ text.authors }}</p>
        <p v-if="text.org" class="modal__org">{{ text.org }}</p>
        <p v-for="(paragraph, index) in text.text" :key="index">
          {{ paragraph }}
        </p>
        <div>
          <img v-if="text.image" :src="text.image" class="modal__image" />
          <p v-if="text.caption" class="modal__image-caption">
            {{ text.caption }}
          </p>
          <small v-if="text.source" class="modal__image-source">{{
            text.source
          }}</small>
        </div>
      </div>
    </div>

    <div
      v-if="isActive && type === 'disclaimer'"
      class="modal__window--disclaimer"
    >
      <button class="modal__close icon--cross" @click.stop="modalClose" />
      <div class="modal__content--disclaimer">
        <h4 class="modal__title">{{ text.title }}</h4>
        <p>{{ text.source }}</p>
        <p>{{ text.text }}</p>
      </div>
    </div>

    <div
      v-if="isActive && type === 'references'"
      class="modal__window--references"
    >
      <button class="modal__close icon--cross" @click.stop="modalClose" />
      <div class="modal__content--references">
        <h4 class="modal__title">{{ text.title }}</h4>
        <p v-for="(paragraph, index) in text.text" :key="index">
          {{ paragraph }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Modal",

  props: {
    isActive: {
      type: Boolean,
      required: true,
    },
    text: {
      type: Object,
      required: true,
    },
    type: {
      type: String,
      default: 'caseStudy'
    }
  },
  methods: {
    modalClose() {
      this.$emit("close-modal")
    },
  },
}
</script>


