<template>
  <div class="min-h-screen flex flex-col items-center justify-center">
    <div class="w-full max-w-md p-8 space-y-8 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
      <div class="flex flex-col items-center justify-center mb-4">
        <span class="text-xl font-extrabold mb-2">
          QUADROS
        </span>

        <div class="grid grid-cols-2 grid-rows-2 gap-0 rounded-2xl shadow-xl overflow-hidden">
          <div class="flex items-center justify-center w-16 h-16 bg-slate-600">
            <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
              <rect x="3" y="3" width="7" height="7" />
              <rect x="14" y="3" width="7" height="7" />
              <rect x="3" y="14" width="7" height="7" />
              <rect x="14" y="14" width="7" height="7" />
            </svg>
          </div>

          <div class="flex items-center justify-center w-16 h-16 bg-green-500">
            <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
            </svg>
          </div>

          <div class="flex items-center justify-center w-16 h-16 bg-orange-500">
            <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="9" />
              <path stroke-linecap="round" d="M12 7v6l4 2" />
            </svg>
          </div>

          <div class="flex items-center justify-center w-16 h-16 bg-purple-600">
            <svg class="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 24 24">
              <circle cx="12" cy="8" r="4" />
              <path d="M4 20c0-4 4-6 8-6s8 2 8 6" />
            </svg>
          </div>
        </div>
      </div>

      <div class="text-center">
        <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white">
          {{ $t('auth.login.title') }}
        </h2>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="handleLogin">
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="email-address" class="sr-only">{{ $t('auth.login.email_label') }}</label>
            <input
              v-model="email"
              id="email-address"
              name="email"
              type="email"
              autocomplete="email"
              required
              class="w-full px-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm border-2 border-solid"
              :placeholder="$t('auth.login.email_placeholder')"
            />
          </div>
          <div>
            <label for="password" class="sr-only">{{ $t('auth.login.password_label') }}</label>
            <input
              v-model="password"
              id="password"
              name="password"
              type="password"
              autocomplete="current-password"
              required
              class="w-full px-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              :placeholder="$t('auth.login.password_placeholder')"
            />
          </div>
        </div>

        <div>
          <BaseButton
            type="submit"
            class="w-full"
            :loading="loading"
          >
            {{ $t('auth.login.submit') }}
          </BaseButton>
        </div>
      </form>
      <div v-if="error" class="text-red-500 text-sm text-center">
        {{ error }}
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

const { t } = useI18n();
const email = ref('user@example.com');
const password = ref('password');
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
