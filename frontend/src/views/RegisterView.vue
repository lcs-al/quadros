<template>
  <div class="min-h-screen flex flex-col items-center justify-center">
    <div class="w-full max-w-md p-8 space-y-8 bg-white dark:bg-gray-800 rounded-lg shadow-lg border border-gray-100 dark:border-gray-700">
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
          {{ $t('auth.register.title') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
          {{ $t('auth.register.subtitle') }}
        </p>
      </div>

      <form class="mt-8 space-y-6" @submit.prevent="handleRegister">
        <!-- Error Message -->
        <div v-if="error" class="bg-red-50 dark:bg-red-900/10 border border-red-200 dark:border-red-800/20 text-red-600 dark:text-red-400 px-4 py-3 rounded-md text-sm">
          <ul class="list-disc list-inside">
            <li v-for="(err, index) in errors" :key="index">{{ err }}</li>
          </ul>
        </div>

        <div class="rounded-md space-y-4">
					<!-- Avatar Upload -->
					<div>
						<label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
							{{ $t('profile.avatar.title') }} ({{ $t('common.optional') }})
						</label>
						<div class="flex items-center space-x-4">
							<div class="h-12 w-12 rounded-full overflow-hidden bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center border-2 border-gray-200 dark:border-gray-600">
								<img v-if="previewUrl" :src="previewUrl" class="h-full w-full object-cover" />
								<font-awesome-icon v-else icon="camera" class="text-gray-400" />
							</div>
							<input 
								ref="fileInputRef"
								type="file" 
								accept="image/*" 
								class="cursor-pointer block w-full text-sm text-gray-500 dark:text-gray-400
									file:mr-4 file:py-2 file:px-4
									file:rounded-md file:border-0
									file:text-sm file:font-semibold
									file:bg-indigo-50 file:text-indigo-700
									hover:file:bg-indigo-100
									dark:file:bg-indigo-900/30 dark:file:text-indigo-300
								"
								@change="handleFileChange"
							/>
						</div>
					</div>

          <!-- Name -->
          <div class="relative group">
            <label for="name" class="sr-only">{{ $t('auth.register.name_label') }}</label>
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400 group-focus-within:text-indigo-500 transition-colors">
              <font-awesome-icon icon="user" />
            </div>
            <input
              v-model="form.name"
              id="name"
              name="name"
              type="text"
              required
              class="w-full pl-3 pr-3 py-2 border-2 text-gray-900 dark:text-white dark:bg-gray-700 border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all shadow-sm"
              :placeholder="$t('auth.register.name_placeholder')"
            />
          </div>

          <!-- Email -->
          <div class="relative group">
            <label for="email-address" class="sr-only">{{ $t('auth.login.email_label') }}</label>
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400 group-focus-within:text-indigo-500 transition-colors">
              <font-awesome-icon icon="envelope" />
            </div>
            <input
              v-model="form.email"
              id="email-address"
              name="email"
              type="email"
              autocomplete="email"
              required
              class="w-full pl-10 pr-3 py-2 border-2 text-gray-900 dark:text-white dark:bg-gray-700 border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all shadow-sm"
              :placeholder="$t('auth.login.email_placeholder')"
            />
          </div>

          <!-- Password -->
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
              v-model="form.password"
              id="password"
              name="password"
              :type="showPassword ? 'text' : 'password'"
              required
              class="w-full pl-3 pr-10 py-2 border-2 text-gray-900 dark:text-white dark:bg-gray-700 border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all shadow-sm"
              :placeholder="$t('auth.login.password_placeholder')"
            />
          </div>

          <!-- Password Confirmation -->
          <div class="relative group">
            <label for="password_confirmation" class="sr-only">{{ $t('auth.register.password_confirmation_label') }}</label>
            <input
              v-model="form.password_confirmation"
              id="password_confirmation"
              name="password_confirmation"
              type="password"
              required
              class="w-full pl-3 pr-3 py-2 border-2 text-gray-900 dark:text-white dark:bg-gray-700 border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all shadow-sm"
              :placeholder="$t('auth.register.password_confirmation_placeholder')"
            />
          </div>
        </div>

        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 transition-colors shadow-sm"
          >
            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
              <font-awesome-icon v-if="!isLoading" icon="user-plus" class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" />
              <font-awesome-icon v-else icon="spinner" class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400 animate-spin" />
            </span>
            {{ isLoading ? $t('common.loading') : $t('auth.register.submit') }}
          </button>
        </div>

        <div class="text-sm text-center">
          <router-link to="/login" class="font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300">
            {{ $t('auth.register.login_link') }}
          </router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';

const authStore = useAuthStore();
const router = useRouter();
const { t } = useI18n();

const form = reactive({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
  avatar: null
});

const showPassword = ref(false);
const error = ref(false);
const errors = ref([]);
const isLoading = ref(false);
const previewUrl = ref(null);
const fileInputRef = ref(null);

const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    if (file.size > 5 * 1024 * 1024) { // 5MB limit
      alert(t('profile.avatar.size_error'));
      event.target.value = '';
      return;
    }
    
    if (!['image/jpeg', 'image/png', 'image/gif', 'image/webp'].includes(file.type)) {
      alert(t('profile.avatar.type_error'));
      event.target.value = '';
      return;
    }

    form.avatar = file;
    previewUrl.value = URL.createObjectURL(file);
  }
};

const handleRegister = async () => {
  error.value = false;
  errors.value = [];
  
  if (form.password !== form.password_confirmation) {
    error.value = true;
    errors.value = [t('auth.register.password_mismatch')];
    return;
  }

  isLoading.value = true;

  const formData = new FormData();
  formData.append('name', form.name);
  formData.append('email', form.email);
  formData.append('password', form.password);
  formData.append('password_confirmation', form.password_confirmation);
  if (form.avatar) {
    formData.append('avatar', form.avatar);
  }

  const result = await authStore.signup(formData);

  if (result.success) {
    router.push('/boards');
  } else {
    error.value = true;
    errors.value = Array.isArray(result.errors) ? result.errors : [result.errors];
  }
  
  isLoading.value = false;
};
</script>
