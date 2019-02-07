<template>
  <div class="tabs">
    <div class="tabs__triggers flex flex-nowrap">
      <button 
        v-for="child, index in children"
        :id="triggerId(child)"
        :aria-controls="child.tabId"
        :aria-selected="child.isActive"
        @click="click(child)" 
        :class="['tab__trigger flex-no-shrink', { 'tab--active' : child.isActive }]">
        <label :for="child.tabId" class="tab__title">{{ child.title }}</label>
      </button>
    </div>
    
    <div class="tab__container">
      <slot></slot>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'tabs',
    
    props: {
      initActiveId: String
    },
    
    data () {
      return {
        children: []
      }
    },
    
    mounted () {
      this.children = this.$children.filter(child => child.$options._componentTag === 'tab')
      this.initTabs()
    },

    methods: {
      click (selectedChild) {
        this.children.forEach(child => {
          child.isActive = child.id === selectedChild.id
        })
      },

      initTabs () {
        this.children.forEach((child, index) => {
          child.isActive = this.initActiveId ? 
            child.tabId === this.initActiveId :
            index === 0
        })
      },

      triggerId (child) {
        return child.tabId + '_trigger'
      }
    }
  }
</script>