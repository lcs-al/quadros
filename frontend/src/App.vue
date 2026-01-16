<script setup>
import { onMounted } from 'vue';
import { useAuthStore } from './stores/auth';
import { useUIStore } from './stores/ui';
import TheNavbar from './components/TheNavbar.vue';
import LoadingBar from './components/common/LoadingBar.vue';

const authStore = useAuthStore();
const uiStore = useUIStore();

onMounted(() => {
  // Global theme initialization
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
    <TheNavbar v-if="authStore.isAuthenticated" />
    <main :class="{ 'pt-16': authStore.isAuthenticated }">
      <router-view />
    </main>
  </div>
</template>

<style>
</style>

