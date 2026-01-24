<script setup>
import { useRoute } from 'vue-router';
import { computed } from 'vue';

const route = useRoute();
const isLoginPage = computed(() => route.path === '/login');
</script>

<template>
  <nav class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-20 py-4 bg-white/80 dark:bg-[#0F111A]/80 backdrop-blur-md border-b border-gray-100 dark:border-gray-800 transition-colors duration-300">
    <router-link to="/" class="flex items-center gap-2 cursor-pointer select-none">
        <div class="grid grid-cols-2 gap-0.5 w-6 h-6 rounded overflow-hidden">
        <div class="bg-indigo-600"></div>
        <div class="bg-green-500"></div>
        <div class="bg-orange-500"></div>
        <div class="bg-purple-600"></div>
      </div>
      <span class="text-xl font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-gray-900 to-gray-600 dark:from-white dark:to-gray-400">{{ $t('navbar.brand') }}</span>
    </router-link>

    <div>
      <router-link 
        to="/login"
        class="px-5 py-2.5 rounded-full text-sm font-semibold text-white bg-gray-900 dark:bg-white dark:text-gray-900 hover:bg-gray-700 dark:hover:bg-gray-200 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
      >
        Entrar
      </router-link>
    </div>
  </nav>
</template>
