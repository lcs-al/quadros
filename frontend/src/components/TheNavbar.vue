<template>
  <nav class="fixed top-0 left-0 right-0 z-50 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 h-16 transition-colors duration-200">
    <div class="lg:px-8 h-full">
      <div class="flex justify-between items-center h-full">
        <div class="flex items-center space-x-8">
          <router-link to="/" class="flex items-center space-x-2">
            <div class="grid grid-cols-2 gap-0.5 w-6 h-6 rounded overflow-hidden">
              <div class="bg-indigo-600"></div>
              <div class="bg-green-500"></div>
              <div class="bg-orange-500"></div>
              <div class="bg-purple-600"></div>
            </div>
            <span class="font-bold text-xl text-indigo-600 dark:text-indigo-400">{{ $t('navbar.brand') }}</span>
          </router-link>
          
          <div class="hidden md:flex items-center space-x-4">
            <router-link 
              to="/" 
              class="text-gray-700 dark:text-gray-200 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium px-3 py-2 rounded-md transition-colors"
              :class="{ 'text-indigo-600 dark:text-indigo-400': $route.name === 'Dashboard' }"
            >
              {{ $t('navbar.boards') }}
            </router-link>
          </div>
        </div>

        <div class="flex items-center space-x-4">
          <button 
            type="button"
            class="p-2 rounded-full text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 relative transition-colors"
            :title="$t('nav.notifications')"
          >
            <span class="sr-only">{{ $t('nav.notifications') }}</span>
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
            <span class="absolute top-1.5 right-1.5 block h-2.5 w-2.5 rounded-full bg-red-500 ring-2 ring-white dark:ring-gray-800"></span>
          </button>

          <div class="relative" ref="settingsRef">
            <button 
              @click="toggleSettings"
              class="p-2 rounded-full text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              :class="{ 'bg-gray-100 dark:bg-gray-700 text-indigo-600 dark:text-indigo-400': showSettings }"
              :title="$t('settings.title')"
            >
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </button>
            <Transition name="scale">
              <div v-if="showSettings" class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-md shadow-lg py-1 z-50">
                <div class="px-4 py-2 border-b border-gray-100 dark:border-gray-600">
                  <p class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">{{ $t('settings.title') }}</p>
                </div>
                
                <div 
                  @click.stop="toggleLanguage"
                  class="px-4 py-2.5 flex items-center justify-between hover:bg-gray-100 dark:hover:bg-gray-600/50 cursor-pointer transition-all duration-200 group"
                >
                  <span class="text-sm text-gray-700 dark:text-gray-200 font-medium group-hover:text-indigo-600 dark:group-hover:text-indigo-400">{{ $t('settings.language') }}</span>
                  <div 
                    class="text-[10px] font-extrabold px-2 py-0.5 rounded bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300 uppercase border border-indigo-200 dark:border-indigo-800"
                  >
                    {{ currentLocale }}
                  </div>
                </div>

                <div 
                  @click.stop="toggleTheme"
                  class="px-4 py-2.5 flex items-center justify-between hover:bg-gray-100 dark:hover:bg-gray-600/50 cursor-pointer transition-all duration-200 group"
                >
                  <span class="text-sm text-gray-700 dark:text-gray-200 font-medium group-hover:text-indigo-600 dark:group-hover:text-indigo-400">{{ $t('settings.theme') }}</span>
                  <div 
                    class="p-1 text-gray-500 dark:text-gray-400 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors"
                  >
                    <svg v-if="isDark" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 9H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                    <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 118.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                    </svg>
                  </div>
                </div>
              </div>
            </Transition>
          </div>

          <div class="relative" ref="userMenuRef">
            <button 
              @click="toggleUserMenu"
              class="flex items-center space-x-2 p-1 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors focus:outline-none"
              :class="{ 'bg-gray-100 dark:bg-gray-700': showUserMenu }"
            >
              <div class="h-8 w-8 rounded-full bg-indigo-500 flex items-center justify-center text-white font-bold border-2 border-white dark:border-gray-800 shadow-sm">
                {{ userInitials }}
              </div>
              <svg 
                class="h-4 w-4 text-gray-500 transition-transform duration-200" 
                :class="{ 'rotate-180': showUserMenu }"
                fill="none" viewBox="0 0 24 24" stroke="currentColor"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
              </svg>
            </button>
            
            <Transition name="scale">
              <div v-if="showUserMenu" class="absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md shadow-lg py-1 z-50">
                <div class="px-4 py-3 border-b border-gray-100 dark:border-gray-700">
                  <p class="text-sm dark:text-gray-200 font-bold truncate">{{ authStore.user?.name }}</p>
                  <p class="text-xs text-gray-500 dark:text-gray-400 truncate">{{ authStore.user?.email }}</p>
                  <p class="text-[10px] mt-1 inline-block px-1.5 py-0.5 rounded bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 uppercase font-bold tracking-tight">
                    {{ authStore.user?.role }}
                  </p>
                </div>

                <div class="py-1 md:hidden">
                  <router-link 
                    to="/" 
                    class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
                    @click="closeMenus"
                  >
                    {{ $t('navbar.boards') }}
                  </router-link>
                </div>

                <div class="py-1 border-t border-gray-100 dark:border-gray-700">
                  <a 
                    href="#" 
                    class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
                    @click="closeMenus"
                  >
                    {{ $t('nav.profile') }}
                  </a>
                </div>

                <div class="py-1 border-t border-gray-100 dark:border-gray-700">
                  <button 
                    @click="handleLogout"
                    role="button"
                    class="w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                  >
                    {{ $t('navbar.logout') }}
                  </button>
                </div>
              </div>
            </Transition>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';

const authStore = useAuthStore();
const router = useRouter();
const locale = useI18n().locale;

const showSettings = ref(false);
const showUserMenu = ref(false);

const settingsRef = ref(null);
const userMenuRef = ref(null);

const isDark = ref(localStorage.getItem('theme') === 'dark');
const currentLocale = computed(() => locale.value.split('_')[0].toUpperCase());

const userInitials = computed(() => {
  if (!authStore.user?.name) return '?';
  const names = authStore.user.name.split(' ');
  if (names.length >= 2) {
    return (names[0][0] + names[names.length - 1][0]).toUpperCase();
  }
  return names[0][0].toUpperCase();
});

const toggleSettings = () => {
  showSettings.value = !showSettings.value;
  if (showSettings.value) showUserMenu.value = false;
};

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value;
  if (showUserMenu.value) showSettings.value = false;
};

const closeMenus = () => {
  showSettings.value = false;
  showUserMenu.value = false;
};

const handleClickOutside = (event) => {
  if (showSettings.value && settingsRef.value && !settingsRef.value.contains(event.target)) {
    showSettings.value = false;
  }
  if (showUserMenu.value && userMenuRef.value && !userMenuRef.value.contains(event.target)) {
    showUserMenu.value = false;
  }
};

const toggleTheme = () => {
  isDark.value = !isDark.value;
  updateTheme();
};

const updateTheme = () => {
  if (isDark.value) {
    document.documentElement.classList.add('dark');
    localStorage.setItem('theme', 'dark');
  } else {
    document.documentElement.classList.remove('dark');
    localStorage.setItem('theme', 'light');
  }
};

const toggleLanguage = () => {
  locale.value = locale.value === 'pt_BR' ? 'en' : 'pt_BR';
  localStorage.setItem('locale', locale.value);
};

const handleLogout = () => {
  authStore.logout();
  router.push('/login');
};

onMounted(() => {
  updateTheme();
  const savedLocale = localStorage.getItem('locale');
  if (savedLocale) {
    locale.value = savedLocale;
  }
  window.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  window.removeEventListener('click', handleClickOutside);
});
</script>
