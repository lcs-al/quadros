<template>
  <div class="min-h-screen flex flex-col bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 font-sans">
    <Navbar />
    <div class="flex-grow flex items-center justify-center pt-16">
      <div class="w-full max-w-md p-8 space-y-8 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
        <div class="flex flex-col items-center justify-center mb-4">
          <div class="grid grid-cols-2 grid-rows-2 gap-0 rounded-2xl shadow-xl overflow-hidden mb-4">
            <div class="flex items-center justify-center w-16 h-16 bg-slate-600">
              <font-awesome-icon icon="th-large" class="w-10 h-10 text-white" />
            </div>

            <div class="flex items-center justify-center w-16 h-16 bg-green-500">
              <font-awesome-icon icon="check" class="w-10 h-10 text-white" />
            </div>

            <div class="flex items-center justify-center w-16 h-16 bg-orange-500">
              <font-awesome-icon icon="clock" class="w-10 h-10 text-white" />
            </div>

            <div class="flex items-center justify-center w-16 h-16 bg-purple-600">
              <font-awesome-icon icon="user-circle" class="w-10 h-10 text-white" />
            </div>
          </div>
        </div>

        <div class="text-center">
          <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white">
            {{ $t('auth.login.title') }}
          </h2>
        </div>
        <form class="mt-8 space-y-6" @submit.prevent="handleLogin">
          <div class="rounded-md shadow-sm space-y-4">
            <div class="relative group">
              <label for="email-address" class="sr-only">{{ $t('auth.login.email_label') }}</label>
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400 group-focus-within:text-indigo-500 transition-colors">
                <font-awesome-icon icon="envelope" />
              </div>
              <input
                v-model="email"
                id="email-address"
                name="email"
                type="email"
                autocomplete="email"
                required
                class="w-full pl-10 pr-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
                :placeholder="$t('auth.login.email_placeholder')"
              />
            </div>
            <div class="relative group">
              <label for="password" class="sr-only">{{ $t('auth.login.password_label') }}</label>
              <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                <button 
                  type="button"
                  @click="showPassword = !showPassword"
                  class="text-gray-400 hover:text-indigo-500 focus:outline-none cursor-pointer transition-colors p-1"
                >
                  <font-awesome-icon :icon="showPassword ? 'eye-slash' : 'eye'" />
                </button>
              </div>
              <input
                v-model="password"
                id="password"
                name="password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="current-password"
                required
                class="w-full pl-3 pr-10 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
                :placeholder="$t('auth.login.password_placeholder')"
              />
            </div>
          </div>

          <div>
            <BaseButton
              type="submit"
              class="w-full cursor-pointer"
              :loading="loading"
            >
              {{ $t('auth.login.submit') }}
            </BaseButton>
          </div>
          <div class="text-sm text-center">
            <router-link to="/register" class="font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300">
               {{ $t('auth.register.title') }}
            </router-link>
          </div>
        </form>
        <div v-if="error" class="text-red-500 text-sm text-center">
          {{ error }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import BaseButton from '../components/common/BaseButton.vue';
import Navbar from '../components/common/Navbar.vue';

const { t } = useI18n();
const email = ref('admin@example.com');
const password = ref('password');
const showPassword = ref(false);
const error = ref('');
const loading = ref(false);
const authStore = useAuthStore();
const router = useRouter();

const handleLogin = async () => {
  error.value = '';
  loading.value = true;
  const success = await authStore.login(email.value, password.value);
  if (success) {
    router.push('/');
  } else {
    error.value = t('auth.error.invalid_credentials');
  }
  loading.value = false;
};
</script>
