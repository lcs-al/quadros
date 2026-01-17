<template>
  <div class="min-h-screen bg-transparent">
    <div class="mx-auto py-6 sm:px-6 lg:px-8">
      <Transition name="fade" mode="out-in">
        <div v-if="loading && boards.length === 0" class="flex flex-col items-center justify-center mt-20 space-y-4">
          <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-600" />
          <p class="text-gray-500 animate-pulse-subtle">{{ $t('dashboard.loading') }}</p>
        </div>
        <div v-else>
          <Transition name="slide-up" appear>
            <div class="mb-8 flex justify-between items-center">
               <div>
                 <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white mb-2">
                   {{ $t('dashboard.select_board') }}
                 </h1>
                 <p class="text-gray-500">{{ $t('dashboard.pick_board_msg') }}</p>
               </div>
               <BaseButton 
                 v-if="authStore.isAdmin"
                 @click="openCreateBoardModal"
                 class="flex items-center space-x-2"
               >
                 <font-awesome-icon icon="plus" class="h-4 w-4" />
                 <span>{{ $t('board.create') }}</span>
               </BaseButton>
            </div>
          </Transition>

          <Transition name="fade" mode="out-in">
            <div v-if="boards.length > 0">
               <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
                  <div 
                    v-for="(board, index) in boards" 
                    :key="board.id" 
                    class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 cursor-pointer hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group relative"
                    :style="{ transitionDelay: `${index * 50}ms` }"
                  >
                    <button
                      v-if="board.created_by?.id === authStore.user?.id"
                      @click.stop="confirmDeleteBoard(board.id)"
                      class="absolute top-3 right-3 p-2 rounded-lg text-gray-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 opacity-0 group-hover:opacity-100 transition-all z-10"
                      :title="$t('board.delete')"
                    >
                      <font-awesome-icon icon="trash-alt" class="h-4 w-4" />
                    </button>
                    
                    <div @click="navigateToBoard(board.id)" class="w-full h-full text-left">
                      <div class="flex items-center justify-between mb-4">
                        <div class="p-3 bg-indigo-50 dark:bg-indigo-900/30 rounded-lg group-hover:bg-indigo-600 transition-colors">
                          <font-awesome-icon icon="columns" class="h-6 w-6 text-indigo-600 dark:text-indigo-400 group-hover:text-white" />
                        </div>
                        
                        <div class="flex flex-col items-end">
                          <span 
                            v-if="board.created_by?.id === authStore.user?.id"
                            class="px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300 rounded"
                          >
                            {{ $t('board.access.owned') }}
                          </span>
                          <span 
                            v-else
                            class="px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider bg-green-100 dark:bg-green-900/50 text-green-700 dark:text-green-300 rounded"
                          >
                            {{ $t('board.access.shared') }}
                          </span>
                        </div>
                      </div>
                      <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ board.title }}</h3>
                      <div class="flex items-center justify-between mt-2">
                        <p class="text-sm text-gray-500">{{ board.columns?.length || 0 }} {{ $t('board.columns') }}</p>
                        
                        <div v-if="board.created_by && board.created_by.id !== authStore.user?.id" class="flex items-center space-x-2">
                           <UserAvatar :user="board.created_by" size="xs" />
                           <span class="text-[10px] text-gray-400 font-medium">{{ board.created_by.name }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
               </div>
            </div>
          </Transition>
        </div>
      </Transition>
    </div>

    <BaseModal
      :isOpen="modalState.createBoard.isOpen"
      :title="$t('board.create_new')"
      @close="modalState.createBoard.isOpen = false"
    >
      <form @submit.prevent="submitCreateBoard">
        <label
          class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
        >
          {{ $t('board.title_prompt') }}
        </label>
        <input
          v-model="modalState.createBoard.title"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 mb-4"
          required
          autofocus
        />
        <div class="flex justify-end space-x-3">
          <BaseButton
            variant="secondary"
            @click="modalState.createBoard.isOpen = false"
          >
            {{ $t('common.cancel') }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.createBoard.loading">
            {{ $t('common.save') }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <BaseModal
      :isOpen="modalState.deleteBoard.isOpen"
      :title="$t('board.delete_confirm_title')"
      @close="modalState.deleteBoard.isOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t('board.delete_confirm_body') }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton
          variant="secondary"
          @click="modalState.deleteBoard.isOpen = false"
        >
          {{ $t('common.cancel') }}
        </BaseButton>
        <BaseButton
          variant="danger"
          :loading="modalState.deleteBoard.loading"
          @click="submitDeleteBoard"
        >
          {{ $t('common.delete') }}
        </BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useUIStore } from '../stores/ui';
import { useRouter } from 'vue-router';
import api from '../api';
import { useI18n } from 'vue-i18n';
import BaseModal from '../components/common/BaseModal.vue';
import BaseButton from '../components/common/BaseButton.vue';
import UserAvatar from '../components/common/UserAvatar.vue';

const { t } = useI18n();

const authStore = useAuthStore();
const uiStore = useUIStore();
const router = useRouter();
const boards = ref([]);
const loading = ref(true);

const modalState = reactive({
  createBoard: { isOpen: false, title: '', loading: false },
  deleteBoard: { isOpen: false, boardId: null, loading: false }
});

const fetchBoards = async () => {
  try {
    const response = await api.get('/boards');
    boards.value = response.data;
  } catch (error) {
    console.error('Failed to fetch boards', error);
  } finally {
    loading.value = false;
  }
};

const navigateToBoard = (boardId) => {
  router.push({ name: 'BoardEdit', params: { id: boardId } });
};

const openCreateBoardModal = () => {
  modalState.createBoard.title = '';
  modalState.createBoard.isOpen = true;
};

const submitCreateBoard = async () => {
  if (!modalState.createBoard.title.trim()) return;
  modalState.createBoard.loading = true;
  try {
    const response = await api.post('/boards', {
      board: { title: modalState.createBoard.title }
    });
    boards.value.push(response.data);
    modalState.createBoard.isOpen = false;
    uiStore.addNotification({
      type: 'success',
      message: t('board.create') + ' - ' + response.data.title
    });
  } catch (error) {
    console.error('Failed to create board', error);
    uiStore.addNotification({
      type: 'error',
      message: error.response?.data?.error || 'Failed to create board'
    });
  } finally {
    modalState.createBoard.loading = false;
  }
};

const confirmDeleteBoard = (boardId) => {
  modalState.deleteBoard.boardId = boardId;
  modalState.deleteBoard.isOpen = true;
};

const submitDeleteBoard = async () => {
  const boardId = modalState.deleteBoard.boardId;
  modalState.deleteBoard.loading = true;
  try {
    await api.delete(`/boards/${boardId}`);
    boards.value = boards.value.filter(b => b.id !== boardId);
    modalState.deleteBoard.isOpen = false;
    uiStore.addNotification({
      type: 'success',
      message: t('board.delete_success')
    });
  } catch (error) {
    console.error('Failed to delete board', error);
    uiStore.addNotification({
      type: 'error',
      message: error.response?.data?.error || 'Failed to delete board'
    });
  } finally {
    modalState.deleteBoard.loading = false;
  }
};

onMounted(() => {
  fetchBoards();
});
</script>
