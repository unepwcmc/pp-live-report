<template>
  <div class="tabs">
    <div class="tabs__triggers gutters">
      <button 
        v-for="(child, index) in children" :key="`child-${index}`"
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
import { eventHub } from '../../packs/application'

  export default {
    name: 'tabs',
    
    props: {
      initActiveId: String,
      id: {
        type: String,
        default: 'tabs-unidentified'
      },
      mapId: {
        type: String,
        default: 'map-unidentified'
      }
    },
    
    data () {
      return {
        children: [],
        selectedId: ''
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

        this.selectedId = selectedChild.id
        this.emitChangeTab()
      },

      emitChangeTab () {
        eventHub.$emit('change-tab', { 
          mapId: this.mapId, 
          tabGroup: this.id, 
          tab: this.selectedId
        })
      },

      initTabs () {
        this.children.forEach((child, index) => {
          child.isActive = this.initActiveId ? 
            child.tabId === this.initActiveId :
            index === 0

          if (child.isActive) {
            this.selectedId = child.tabId
          }
        })
      },

      triggerId (child) {
        return child.tabId + '_trigger'
      }
    }
  }
</script>