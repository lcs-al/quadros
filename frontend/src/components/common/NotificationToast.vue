<template>
  <div class="fixed bottom-4 right-4 z-[100] space-y-2 pointer-events-none">
    <TransitionGroup name="notification">
      <div 
        v-for="notification in uiStore.notifications" 
        :key="notification.id"
        class="pointer-events-auto flex items-center p-4 rounded-lg shadow-lg border bg-white dark:bg-[#1A1D26] border-gray-100 dark:border-gray-700 max-w-sm w-full animate-slide-in"
      >
        <div class="flex-1">
          <p class="text-sm font-medium text-gray-900 dark:text-white">{{ notification.message }}</p>
        </div>
        <div v-if="notification.action" class="ml-4 flex-shrink-0 flex">
          <button 
            @click="handleAction(notification)"
            class="text-indigo-600 dark:text-indigo-400 text-sm font-bold hover:text-indigo-500 transition-colors"
          >
            {{ notification.action.label }}
          </button>
        </div>
        <div class="ml-4 flex-shrink-0 flex">
          <button 
            @click="uiStore.removeNotification(notification.id)"
            class="text-gray-400 hover:text-gray-500"
          >
            <font-awesome-icon icon="times" class="h-4 w-4" />
          </button>
        </div>
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup>
import { useUIStore } from '../../stores/ui';

const uiStore = useUIStore();

const handleAction = (notification) => {
  if (notification.action && notification.action.callback) {
    notification.action.callback();
  }
  uiStore.removeNotification(notification.id);
};
</script>

<style scoped>
.notification-enter-active,
.notification-leave-active {
  transition: all 0.3s ease;
}
.notification-enter-from {
  opacity: 0;
  transform: translateX(30px);
}
.notification-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>
