<template>
  <div class="min-h-screen flex flex-col items-center justify-center">
    <div class="w-full max-w-md p-8 space-y-8 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
      <div class="flex flex-col items-center justify-center mb-4">
        <span class="mb-2 text-2xl font-semibold text-gray-900 dark:text-white">
          {{ $t('navbar.brand') }}
        </span>

        <div class="grid grid-cols-2 grid-rows-2 gap-0 rounded-2xl shadow-xl overflow-hidden">
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
