<template>
  <form @submit.prevent="submitInvite" class="space-y-4 pt-4 border-t border-gray-100 dark:border-gray-700">
    <h4 class="text-sm font-bold text-gray-900 dark:text-white mb-2">
      {{ $t('board.members.invite') }}
    </h4>
    <div class="flex flex-col sm:flex-row gap-3">
      <div class="flex-1">
        <input
          v-model="email"
          type="email"
          :placeholder="$t('board.members.invite_placeholder')"
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 text-sm"
          required
        />
      </div>
      <div class="w-full sm:w-32">
        <select
          v-model="role"
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 text-sm appearance-none"
        >
          <option value="viewer">{{ $t('board.members.role.viewer') }}</option>
          <option value="editor">{{ $t('board.members.role.editor') }}</option>
        </select>
      </div>
      <BaseButton
        type="submit"
        size="sm"
        :loading="loading"
        class="whitespace-nowrap"
      >
        <font-awesome-icon icon="paper-plane" class="mr-2" />
        {{ $t('common.save') }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup>
import { ref } from 'vue';
import BaseButton from './common/BaseButton.vue';

const props = defineProps({
  loading: Boolean
});

const emit = defineEmits(['invite']);

const email = ref('');
const role = ref('viewer');

const submitInvite = () => {
  if (!email.value.trim()) return;
  emit('invite', { email: email.value, role: role.value });
};

defineExpose({
  reset() {
    email.value = '';
    role.value = 'viewer';
  }
});
</script>
