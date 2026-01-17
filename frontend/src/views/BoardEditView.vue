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
                     class="text-2xl font-bold bg-white dark:bg-gray-800 border-2 border-indigo-500 rounded-md px-2 py-1 focus:outline-none w-full text-gray-900 dark:text-white shadow-sm"
                   />
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
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import api from '../api';
import BoardDetail from '../components/BoardDetail.vue';

const { t } = useI18n();
const route = useRoute();
const router = useRouter();

const board = ref(null);
const loading = ref(true);
const isEditingTitle = ref(false);
const editTitleValue = ref('');
const titleInput = ref(null);

const fetchBoardDetails = async () => {
  loading.value = true;
  try {
    const response = await api.get(`/boards/${route.params.id}`);
    board.value = response.data;
  } catch (error) {
    console.error('Failed to fetch board details', error);
    // If board not found, redirect to boards list
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

// Update document title when board changes
watch(board, (newBoard) => {
  const baseTitle = t('app.name') || 'Quadros';
  if (newBoard) {
    document.title = `${baseTitle} | ${newBoard.title}`;
  }
}, { immediate: true });

onMounted(() => {
  fetchBoardDetails();
});
</script>
