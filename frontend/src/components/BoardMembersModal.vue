<template>
  <BaseModal
    :isOpen="isOpen"
    :title="$t('board.members.manage')"
    @close="$emit('close')"
  >
    <div class="space-y-6">
      <!-- Members List -->
      <div class="space-y-4 max-h-[300px] overflow-y-auto pr-2">
        <!-- Owner -->
        <div v-if="owner" class="flex items-center justify-between p-3 bg-gray-50 dark:bg-[#1A1D26]/50 rounded-lg">
          <div class="flex items-center space-x-3">
            <UserAvatar :user="owner" size="md" />
            <div>
              <p class="text-sm font-bold text-gray-900 dark:text-white">{{ owner.name }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ owner.email }}</p>
            </div>
          </div>
          <span class="px-2 py-1 text-[10px] font-bold uppercase tracking-wider bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300 rounded">
            {{ $t('board.members.owner') }}
          </span>
        </div>

        <!-- Members -->
        <div 
          v-for="membership in memberships" 
          :key="membership.id"
          class="flex items-center justify-between p-3 border border-gray-100 dark:border-gray-700 rounded-lg group"
        >
          <div class="flex items-center space-x-3">
            <UserAvatar :user="membership.user" size="md" />
            <div>
              <p class="text-sm font-bold text-gray-900 dark:text-white">{{ membership.user?.name }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ membership.user?.email }}</p>
            </div>
          </div>
          
          <div class="flex items-center space-x-3">
            <select
              :value="membership.role"
              @change="updateRole(membership, $event.target.value)"
              class="text-xs bg-transparent border-none focus:ring-0 text-gray-600 dark:text-gray-300 cursor-pointer font-medium hover:text-indigo-600 transition-colors"
            >
              <option value="viewer">{{ $t('board.members.role.viewer') }}</option>
              <option value="editor">{{ $t('board.members.role.editor') }}</option>
            </select>

            <button
              @click="removeMember(membership)"
              class="p-1 px-2 text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded transition-colors"
              :title="$t('board.members.remove')"
            >
              <font-awesome-icon icon="trash-alt" class="h-3 w-3" />
            </button>
          </div>
        </div>
      </div>

      <!-- Invite Form -->
      <InviteUserForm
        ref="inviteFormRef"
        :loading="inviteLoading"
        @invite="onInvite"
      />
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import BaseModal from './common/BaseModal.vue';
import UserAvatar from './common/UserAvatar.vue';
import InviteUserForm from './InviteUserForm.vue';
import api from '../api';
import { useUIStore } from '../stores/ui';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  isOpen: Boolean,
  boardId: [Number, String],
  owner: Object
});

const emit = defineEmits(['close', 'refresh']);
const { t } = useI18n();
const uiStore = useUIStore();

const memberships = ref([]);
const loading = ref(false);
const inviteLoading = ref(false);
const inviteFormRef = ref(null);

const fetchMemberships = async () => {
  if (!props.boardId) return;
  loading.value = true;
  try {
    const response = await api.get(`/boards/${props.boardId}/memberships`);
    memberships.value = response.data;
  } catch (error) {
    console.error('Failed to fetch memberships', error);
  } finally {
    loading.value = false;
  }
};

const onInvite = async ({ email, role }) => {
  inviteLoading.value = true;
  try {
    const response = await api.post(`/boards/${props.boardId}/memberships`, {
      membership: { email, role }
    });
    memberships.value.push(response.data);
    inviteFormRef.value?.reset();
    uiStore.addNotification({
      type: 'success',
      message: t('board.members.invite_success')
    });
  } catch (error) {
    console.error('Failed to invite member', error);
    const message = error.response?.status === 404 
      ? t('board.members.not_found') 
      : (error.response?.data?.error || t('board.members.not_found'));
    
    uiStore.addNotification({
      type: 'error',
      message
    });
  } finally {
    inviteLoading.value = false;
  }
};

const updateRole = async (membership, newRole) => {
  try {
    await api.patch(`/boards/${props.boardId}/memberships/${membership.id}`, {
      membership: { role: newRole }
    });
    membership.role = newRole;
    uiStore.addNotification({
      type: 'success',
      message: t('board.members.update_success')
    });
  } catch (error) {
    console.error('Failed to update role', error);
  }
};

const removeMember = async (membership) => {
  try {
    await api.delete(`/boards/${props.boardId}/memberships/${membership.id}`);
    memberships.value = memberships.value.filter(m => m.id !== membership.id);
    uiStore.addNotification({
      type: 'success',
      message: t('board.members.remove_success')
    });
  } catch (error) {
    console.error('Failed to remove member', error);
  }
};

onMounted(() => {
  fetchMemberships();
});
</script>
