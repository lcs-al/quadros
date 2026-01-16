<template>
  <div 
    v-show="uiStore.isLoading"
    class="fixed top-0 left-0 right-0 z-[100] h-1 bg-transparent overflow-hidden"
  >
    <div class="h-full bg-indigo-600 dark:bg-indigo-400 animate-loading-bar shadow-[0_0_10px_rgba(79,70,229,0.5)]"></div>
  </div>
</template>

<script setup>
import { useUIStore } from '../../stores/ui';

const uiStore = useUIStore();
</script>

<style scoped>
.animate-loading-bar {
  width: 100%;
  animation: loading 2s ease-in-out infinite;
  transform-origin: left;
}

@keyframes loading {
  0% { transform: scaleX(0) translateX(0); }
  50% { transform: scaleX(0.5) translateX(50%); }
  100% { transform: scaleX(0) translateX(200%); }
}
</style>
