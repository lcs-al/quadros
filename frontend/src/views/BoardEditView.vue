<template>
  <div class="min-h-screen bg-transparent">
    <div class="mx-auto py-6 sm:px-6 lg:px-8">
      <Transition name="fade" mode="out-in">
        <div v-if="loading && !board" class="flex flex-col items-center justify-center mt-20 space-y-4">
          <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-600" />
          <p class="text-gray-500 animate-pulse-subtle">{{ $t('dashboard.loading') }}</p>
        </div>
        <div v-else-if="board">
          <!-- Board Detail View Header with Back Button -->
          <Transition name="slide-up" appear>
            <div class="mb-6 flex items-center justify-between">
               <div class="flex items-center space-x-4">
                 <!-- Back to Boards Button -->
                 <button
                   @click="backToBoards"
                   class="p-2 rounded-lg text-gray-500 hover:text-indigo-600 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 dark:text-gray-400 dark:hover:text-indigo-400 transition-all"
                   :title="$t('board.back_to_boards')"
                 >
                   <font-awesome-icon icon="arrow-left" class="h-5 w-5" />
                 </button>
                 
                 <div v-if="!isEditingTitle" @click="startEditing" class="flex items-center space-x-3 cursor-pointer group">
                   <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                     {{ board.title }}
                   </h1>
                   <font-awesome-icon 
                     icon="pencil-alt" 
                     class="text-gray-400 opacity-0 group-hover:opacity-100 transition-opacity duration-200 h-4 w-4" 
                   />
                 </div>
                 <div v-else class="w-full max-w-md">
                   <input 
                     ref="titleInput"
                     v-model="editTitleValue"
                     @blur="saveTitle"
                     @keyup.enter="saveTitle"
                     @keyup.esc="cancelEditing"
                     type="text" 
                     class="text-2xl font-bold bg-white dark:bg-[#1A1D26] border-2 border-indigo-500 rounded-md px-2 py-1 focus:outline-none w-full text-gray-900 dark:text-white shadow-sm"
                   />
                 </div>
               </div>

                <!-- Right Side Actions -->
                <div class="flex items-center space-x-3" v-if="board">
                  <!-- Manage Members Button (Owner Only) -->
                  <BaseButton
                    v-if="board.created_by?.id === authStore.user?.id"
                    variant="secondary"
                    size="sm"
                    @click="isMembersModalOpen = true"
                    class="flex items-center space-x-2"
                  >
                    <font-awesome-icon icon="users" class="h-4 w-4" />
                    <span>{{ $t('board.members.manage') }}</span>
                  </BaseButton>

                  <!-- Backlog Button -->
                  <BaseButton
                    variant="secondary"
                    size="sm"
                    @click="goToBacklog"
                    class="flex items-center space-x-2"
                  >
                    <font-awesome-icon icon="clipboard-list" class="h-4 w-4" />
                    <span>{{ $t('board.backlog.go_to') }}</span>
                  </BaseButton>

                  <!-- Conclude Tasks Button (Owner/Editor) -->
                  <BaseButton
                    variant="success"
                    size="sm"
                    @click="concludeTasks"
                    :loading="concludingTasks"
                    class="flex items-center space-x-2"
                    :title="$t('board.conclude_tasks_tooltip')"
                  >
                    <font-awesome-icon icon="check-double" class="h-4 w-4" />
                    <span>{{ $t('board.conclude_tasks') }}</span>
                  </BaseButton>
                  
                  <!-- Member Avatars -->
                  <div class="flex -space-x-2 overflow-hidden">
                    <UserAvatar 
                      v-if="board.created_by"
                      :user="board.created_by" 
                      size="sm" 
                      class="inline-block ring-2 ring-white dark:ring-gray-800"
                      :title="`${$t('board.members.owner')}: ${board.created_by.name}`"
                    />
                    <UserAvatar 
                      v-for="member in board.members?.slice(0, 3)" 
                      :key="member.id"
                      :user="member" 
                      size="sm" 
                      class="inline-block ring-2 ring-white dark:ring-gray-800"
                      :title="member.name"
                    />
                    <div 
                      v-if="board.members?.length > 3"
                      class="flex items-center justify-center w-8 h-8 rounded-full bg-gray-100 dark:bg-gray-700 ring-2 ring-white dark:ring-gray-800 text-[10px] font-bold text-gray-500"
                    >
                      +{{ board.members.length - 3 }}
                    </div>
                  </div>
                </div>
            </div>
          </Transition>

          <!-- Board Detail Component -->
          <Transition name="fade" mode="out-in">
            <BoardDetail :board="board" @refresh="fetchBoardDetails" />
          </Transition>
        </div>
      </Transition>
    </div>

    <!-- Board Members Modal -->
    <BoardMembersModal
      v-if="board"
      :isOpen="isMembersModalOpen"
      :boardId="board.id"
      :owner="board.created_by"
      @close="isMembersModalOpen = false"
      @refresh="fetchBoardDetails"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import { useBoardStore } from '../stores/boards';
import { useI18n } from "vue-i18n";
import api from '../api';
import BoardDetail from '../components/BoardDetail.vue';
import BoardMembersModal from '../components/BoardMembersModal.vue';
import BaseButton from '../components/common/BaseButton.vue';
import UserAvatar from '../components/common/UserAvatar.vue';
import consumer from '../services/cable';


const { t } = useI18n();
const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const boardStore = useBoardStore();

const board = ref(null);
const loading = ref(true);
const isEditingTitle = ref(false);
const editTitleValue = ref('');
const titleInput = ref(null);
const isMembersModalOpen = ref(false);
const concludingTasks = ref(false);

const concludeTasks = async () => {
  if (!confirm(t('board.confirm_conclude_tasks'))) return;

  concludingTasks.value = true;
  try {
    await api.post(`/boards/${board.value.id}/conclude_cards`);
    await fetchBoardDetails();
  } catch (error) {
    console.error('Failed to conclude cards', error);
  } finally {
    concludingTasks.value = false;
  }
};

const fetchBoardDetails = async () => {
  loading.value = true;
  try {
    const response = await api.get(`/boards/${route.params.id}`);
    board.value = response.data;
    boardStore.addToRecent(board.value);
  } catch (error) {
    console.error('Failed to fetch board details', error);
    router.push({ name: 'BoardsList' });
  } finally {
    loading.value = false;
  }
};

const startEditing = () => {
  if (board.value) {
    editTitleValue.value = board.value.title;
    isEditingTitle.value = true;
    nextTick(() => {
      titleInput.value?.focus();
    });
  }
};

const saveTitle = async () => {
  if (!isEditingTitle.value) return;
  const oldTitle = board.value.title;
  const newTitle = editTitleValue.value.trim();

  if (newTitle && newTitle !== oldTitle) {
    try {
      const response = await api.patch(`/boards/${board.value.id}`, {
        board: { title: newTitle }
      });
      board.value.title = response.data.title;
    } catch (error) {
      console.error('Failed to update board title', error);
      editTitleValue.value = oldTitle;
    }
  }
  isEditingTitle.value = false;
};

const cancelEditing = () => {
  isEditingTitle.value = false;
};

const backToBoards = () => {
  router.push({ name: 'BoardsList' });
};

const goToBacklog = () => {
  router.push({ name: 'BoardBacklog', params: { id: board.value.id } });
};



let subscription;

const subscribeToBoard = (boardId) => {
  if (subscription) {
    subscription.unsubscribe();
  }

  subscription = consumer.subscriptions.create(
    { channel: 'BoardChannel', board_id: boardId },
    {
      received(data) {
        if (data.action === 'refresh') {
          fetchBoardDetails();
        }
      }
    }
  );
};

// Update document title when board changes
watch(board, (newBoard) => {
  const baseTitle = t('app.name') || 'Quadros';
  if (newBoard) {
    document.title = `${baseTitle} | ${newBoard.title}`;
    
     if (newBoard.id && (!subscription || JSON.parse(subscription.identifier).board_id !== newBoard.id)) {
       subscribeToBoard(newBoard.id);
    }
  }
}, { immediate: true });

watch(() => route.params.id, (newId) => {
  if (newId) {
    fetchBoardDetails();
    // Subscription will be handled by the board watcher once details are fetched
  }
});

onMounted(() => {
  fetchBoardDetails();
});

onUnmounted(() => {
  if (subscription) {
    subscription.unsubscribe();
  }
});
</script>
