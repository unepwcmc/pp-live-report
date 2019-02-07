<template>
  <div v-show="isActive" :id="tabId" :aria-labelledby="triggerId" class="tab">
    <slot></slot>
  </div>
</template>

<script>
  export default {
    name: 'tab',
    
    props: {
      id: {
        required: true,
        type: String
      },
      title: {
        required: true,
        type: String
      }
    },

    data() {
      return {
        isActive: false,
        tabId: this.id
      };
    },

    computed: {
      triggerId () {
        return this.tabId + '_trigger'
      }
    }
  }
</script>