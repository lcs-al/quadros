<script setup>
import { onMounted, ref } from 'vue';
import { useAuthStore } from './stores/auth';
import { useUIStore } from './stores/ui';
import TheNavbar from './components/TheNavbar.vue';
import Sidebar from './components/common/Sidebar.vue';
import LoadingBar from './components/common/LoadingBar.vue';
import NotificationToast from './components/common/NotificationToast.vue';

const authStore = useAuthStore();
const uiStore = useUIStore();
const isSidebarExpanded = ref(true);

onMounted(() => {
  const isDark = localStorage.getItem('theme') === 'dark';
  if (isDark) {
    document.documentElement.classList.add('dark');
  } else {
    document.documentElement.classList.remove('dark');
  }
});
</script>

<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 font-sans transition-colors duration-200">
    <LoadingBar />
    <NotificationToast />
    <Sidebar 
      v-if="authStore.isAuthenticated" 
      :is-expanded="isSidebarExpanded"
      @toggle="isSidebarExpanded = !isSidebarExpanded"
    />
    <TheNavbar 
      v-if="authStore.isAuthenticated" 
      class="transition-all duration-300"
    />
    <main 
      :class="{ 
        'pt-16': authStore.isAuthenticated,
        'transition-all duration-300': true,
        'ml-64': authStore.isAuthenticated && isSidebarExpanded,
        'ml-20': authStore.isAuthenticated && !isSidebarExpanded
      }"
    >
      <router-view />
    </main>
  </div>
</template>

<style>
</style>

