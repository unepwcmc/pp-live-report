<template>
  <div 
    :class="[isActive ? 'modal-wrapper--active' : 'modal-wrapper']"
    @click.stop.self="modalClose"
  >
    <div
      v-if="isActive && type === 'caseStudy'"
      class="modal__window--case-study"
    >
      <button class="modal__close icon--cross" @click.stop="modalClose" />
      <div class="modal__content--case-study">
        <p v-if="text.report" class="modal__report">{{ text.report }}</p>
        <h2 class="modal__title">{{ text.title }}</h2>
        <template v-show="text.authors">
          <p 
            v-for="author, i in text.authors"
            :key="`author-${Math.random(1000*i)}`"
          >
            <span>{{ author.name }}</span><br>
            <span class="italic">{{ author.org }}</span>
          </p>
        </template>

        <div class="modal__figure">
          <img v-if="text.image" :src="text.image" class="modal__image" />
          <p 
            v-if="text.caption" 
            class="modal__image-caption"
            v-html="text.caption"
          />
          <small 
            v-if="text.source" 
            class="modal__image-source"
            v-html="text.source"
          />
        </div>

        <p 
          v-for="(paragraph, index) in text.text" 
          :key="index"
          v-html="paragraph"
        />

        <p>
          <small v-if="text.card_source" class="modal__image-source">
            Photo credit: {{ text.card_source }}
          </small>
        </p>
      </div>
    </div>

    <div
      v-if="isActive && type === 'disclaimer'"
      class="modal__window--disclaimer"
    >
      <button class="modal__close icon--cross" @click.stop="modalClose" />
      <div class="modal__content--disclaimer">
        <h4 class="modal__title">{{ text.title }}</h4>
        <p v-html="text.source"/>
        <p v-html="text.text"/>
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


