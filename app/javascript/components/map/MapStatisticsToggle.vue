<template>
 <div
  @click="toggleLayer"
  :class="['map__panel-toggle no-select', toggleClasses]"
 >
  <slot></slot>
 </div>
</template>

<script>
import { eventHub } from "../../packs/application.js";

export default {
 name: "map-statistics-toggle",

 props: {
  isActive: {
   type: Boolean,
  },
  ids: {
   type: Array,
   required: true,
  },
  layerNo: {
   type: Number,
   required: true,
  },
  parentTabId: String,
  mapId: String,
 },

 data() {
  return {
   isDisabled: true,
  };
 },

 created() {
  eventHub.$on("change-tab", this.handleTabChange);
  eventHub.$on("hideOtherLayers", this.hideLayerIfNotSelected);
 },

 computed: {
  toggleClasses() {
   return {
    active: this.isActive,
   };
  },
 },

 methods: {
  handleTabChange(ids) {
   if ("tabs-" + this.mapId !== ids.tabGroup || this.layerNo !== 0) {
    return;
   }

   this.parentTabId === ids.tab ? this.showLayers() : this.hideLayers();
  },

  toggleLayer() {
   if (this.isActive === true) {
    return;
   }
   this.hideOtherLayers();
   this.showLayers();
  },

  showLayers() {
   eventHub.$emit("showLayers", { mapId: this.mapId, layerIds: this.ids });
  },

  hideLayers() {
   eventHub.$emit("hideLayers", { mapId: this.mapId, layerIds: this.ids });
  },

  hideOtherLayers() {
   eventHub.$emit("hideOtherLayers", {
    mapId: this.mapId,
    layerIds: this.ids,
    layerNo: this.layerNo,
   });
  },

  hideLayerIfNotSelected(obj) {
    if (obj.layerNo === this.layerNo) { return }
    this.hideLayers();
  }
 },
};
</script>