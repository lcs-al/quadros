<template>
  <div class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8 mt-16">
    <div class="bg-white dark:bg-gray-800 shadow rounded-lg overflow-hidden transition-colors duration-200">
      <div class="px-4 py-5 border-b border-gray-200 dark:border-gray-700 sm:px-6">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">{{ $t('profile.title') }}</h1>
      </div>

      <div class="p-6 space-y-8">
        <!-- Avatar Section -->
        <section>
          <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">{{ $t('profile.avatar.title') }}</h2>
          <div class="flex items-center space-x-6">
            <div class="relative group">
              <div class="h-24 w-24 rounded-full bg-indigo-500 flex items-center justify-center text-white text-3xl font-bold border-4 border-white dark:border-gray-700 shadow-lg overflow-hidden transition-transform duration-200 group-hover:scale-105">
                <img v-if="previewUrl || authStore.user?.avatar_url" :src="previewUrl || authStore.user?.avatar_url" class="h-full w-full object-cover" />
                <span v-else>{{ userInitials }}</span>
              </div>
              <label for="avatar-upload" class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-40 text-white opacity-0 group-hover:opacity-100 cursor-pointer rounded-full transition-opacity duration-200">
                <font-awesome-icon icon="camera" class="h-6 w-6" />
              </label>
              <input 
                id="avatar-upload" 
                type="file" 
                class="hidden" 
                accept="image/*" 
                @change="handleFileChange" 
              />
            </div>
            <div class="flex flex-col space-y-2">
              <button 
                @click="triggerUpload"
                class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm"
              >
                {{ $t('profile.avatar.change') }}
              </button>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ $t('profile.avatar.file_format_hint') }}</p>
            </div>
          </div>
        </section>

        <!-- Personal Info Section -->
        <section class="border-t border-gray-100 dark:border-gray-700 pt-8">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">{{ $t('profile.personal_info') }}</h2>
          <form @submit.prevent="handleUpdateProfile" class="grid grid-cols-1 gap-y-6 sm:grid-cols-2 sm:gap-x-8">
            <div class="sm:col-span-1">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">{{ $t('profile.fields.name') }}</label>
              <input 
                v-model="form.name"
                type="text" 
                class="w-full pl-3 pr-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
                required
              />
            </div>
            <div class="sm:col-span-1">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">{{ $t('profile.fields.email') }}</label>
              <input 
                :value="authStore.user?.email"
                disabled
                type="email" 
                class="w-full pl-3 pr-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
              />
            </div>

            <div class="sm:col-span-2 pt-4">
              <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">{{ $t('profile.security') }}</h2>
            </div>

            <div class="sm:col-span-1">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">{{ $t('profile.fields.password') }}</label>
              <input 
                v-model="form.password"
                type="password" 
                class="w-full pl-3 pr-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
                autocomplete="new-password"
              />
            </div>
            <div class="sm:col-span-1">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">{{ $t('profile.fields.password_confirmation') }}</label>
              <input 
                v-model="form.password_confirmation"
                type="password" 
                class="w-full pl-3 pr-3 py-2 border-2 dark:border-gray-600 text-gray-900 dark:text-white dark:bg-gray-700 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-solid transition-all"
                autocomplete="new-password"
              />
            </div>

            <div class="sm:col-span-2 flex justify-end space-x-3 pt-4">
              <button 
                type="button"
                @click="resetForm"
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
              >
                {{ $t('common.cancel') }}
              </button>
              <button 
                type="submit"
                :disabled="isLoading"
                class="px-6 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm disabled:opacity-50 flex items-center"
              >
                <font-awesome-icon v-if="isLoading" icon="spinner" class="animate-spin mr-2" />
                {{ $t('common.save') }}
              </button>
            </div>
          </form>
        </section>

        <!-- Feedback Messages -->
        <Transition name="fade">
          <div v-if="feedback" :class="feedbackClass" class="p-4 rounded-md">
            <div class="flex">
              <div class="flex-shrink-0">
                <font-awesome-icon :icon="feedbackIcon" class="h-5 w-5" />
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium">{{ feedback.message }}</p>
                <ul v-if="feedback.errors" class="mt-2 text-sm list-disc list-inside">
                  <li v-for="err in feedback.errors" :key="err">{{ err }}</li>
                </ul>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useI18n } from 'vue-i18n';

const authStore = useAuthStore();
const { t } = useI18n();

const form = reactive({
  name: authStore.user?.name || '',
  password: '',
  password_confirmation: '',
  avatar: null
});

const previewUrl = ref(null);
const isLoading = ref(false);
const feedback = ref(null);

const userInitials = computed(() => {
  if (!authStore.user?.name) return '?';
  const names = authStore.user.name.split(' ');
  if (names.length >= 2) {
    return (names[0][0] + names[names.length - 1][0]).toUpperCase();
  }
  return names[0][0].toUpperCase();
});

const feedbackClass = computed(() => {
  if (!feedback.value) return '';
  return feedback.value.type === 'success' 
    ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400'
    : 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400';
});

const feedbackIcon = computed(() => {
  if (!feedback.value) return null;
  return feedback.value.type === 'success' ? 'check-circle' : 'exclamation-circle';
});

const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    if (file.size > 2 * 1024 * 1024) {
      showFeedback('error', t('profile.avatar.size_error'));
      return;
    }
    form.avatar = file;
    previewUrl.value = URL.createObjectURL(file);
  }
};

const triggerUpload = () => {
  document.getElementById('avatar-upload').click();
};

const resetForm = () => {
  form.name = authStore.user?.name || '';
  form.password = '';
  form.password_confirmation = '';
  form.avatar = null;
  previewUrl.value = null;
  feedback.value = null;
};

const handleUpdateProfile = async () => {
  isLoading.value = true;
  feedback.value = null;

  const formData = new FormData();
  formData.append('name', form.name);
  if (form.password) {
    formData.append('password', form.password);
    formData.append('password_confirmation', form.password_confirmation);
  }
  if (form.avatar) {
    formData.append('avatar', form.avatar);
  }

  const result = await authStore.updateProfile(formData);

  if (result.success) {
    showFeedback('success', t('profile.success'));
    form.password = '';
    form.password_confirmation = '';
    form.avatar = null;
    previewUrl.value = null;
  } else {
    showFeedback('error', t('profile.errors.update_failed'), result.errors);
  }
  isLoading.value = false;
};

const showFeedback = (type, message, errors = null) => {
  feedback.value = { type, message, errors };
  if (type === 'success') {
    setTimeout(() => {
      feedback.value = null;
    }, 5000);
  }
};

onMounted(async () => {
  await authStore.fetchMe();
  form.name = authStore.user?.name || '';
});
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
