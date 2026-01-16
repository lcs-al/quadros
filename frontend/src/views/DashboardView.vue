<template>
  <div class="min-h-screen bg-transparent">
    <!-- Content -->
    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <Transition name="fade" mode="out-in">
        <div v-if="loading && boards.length === 0" class="flex flex-col items-center justify-center mt-20 space-y-4">
          <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-600" />
          <p class="text-gray-500 animate-pulse-subtle">{{ $t('dashboard.loading') }}</p>
        </div>
        <div v-else>
          <!-- Board Selection -->
          <Transition name="slide-up" appear>
            <div class="mb-8 flex justify-between items-center" v-if="!currentBoard">
               <div>
                 <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white mb-2">
                   {{ $t('dashboard.select_board') }}
                 </h1>
                 <p class="text-gray-500">{{ $t('dashboard.pick_board_msg') }}</p>
               </div>
            </div>
            <div v-else class="mb-6">
               <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                 {{ currentBoard.title }}
               </h1>
            </div>
          </Transition>

          <Transition name="fade" mode="out-in">
            <div v-if="!currentBoard && boards.length > 0">
               <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
                  <div 
                    v-for="(board, index) in boards" 
                    :key="board.id" 
                    @click="selectBoard(board.id)" 
                    class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 cursor-pointer hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group"
                    :style="{ transitionDelay: `${index * 50}ms` }"
                  >
                    <div class="flex items-center justify-between mb-4">
                      <div class="p-3 bg-indigo-50 dark:bg-indigo-900/30 rounded-lg group-hover:bg-indigo-600 transition-colors">
                        <font-awesome-icon icon="columns" class="h-6 w-6 text-indigo-600 dark:text-indigo-400 group-hover:text-white" />
                      </div>
                    </div>
                    <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ board.title }}</h3>
                    <p class="text-sm text-gray-500 mt-2">{{ board.columns?.length || 0 }} {{ $t('board.columns') || 'columns' }}</p>
                  </div>
               </div>
            </div>
            <!-- Kanban Board Component -->
            <BoardDetail v-else-if="currentBoard" :board="currentBoard" @refresh="fetchBoardDetails" />
          </Transition>
        </div>
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import api from '../api';
import BoardDetail from '../components/BoardDetail.vue';

const authStore = useAuthStore();
const router = useRouter();
const boards = ref([]);
const currentBoard = ref(null);
const loading = ref(true);

const logout = () => {
  authStore.logout();
  router.push('/login');
};

const fetchBoards = async () => {
  try {
    const response = await api.get('/boards');
    boards.value = response.data;
    if (boards.value.length > 0) {
       // Automatically select the first board for demo purposes or let user select
       // For now, let's just list them if not selected
    }
  } catch (error) {
    console.error('Failed to fetch boards', error);
  } finally {
    loading.value = false;
  }
};

const selectBoard = async (boardId) => {
  loading.value = true;
  try {
    const response = await api.get(`/boards/${boardId}`);
    currentBoard.value = response.data;
  } catch (error) {
    console.error('Failed to fetch board details', error);
  } finally {
     loading.value = false;
  }
}

watch(currentBoard, (newBoard) => {
  const baseTitle = 'Quadros';
  if (newBoard) {
    document.title = `${baseTitle} | ${newBoard.title}`;
  } else {
    document.title = `${baseTitle} | Dashboard`;
  }
}, { immediate: true });

const fetchBoardDetails = async () => {
   if (currentBoard.value) {
      await selectBoard(currentBoard.value.id);
   }
}

onMounted(() => {
  fetchBoards();
});
</script>
