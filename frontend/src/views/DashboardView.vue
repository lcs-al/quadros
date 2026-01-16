<template>
  <div class="min-h-screen bg-transparent">
    <!-- Content -->
    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <div v-if="loading" class="text-center text-gray-500 mt-10">
        {{ $t('dashboard.loading') }}
      </div>
      <div v-else>
        <!-- Board Selection (Simple Dropdown or List for now) -->
        <div class="mb-6 flex justify-between items-center">
           <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
             {{ currentBoard ? currentBoard.title : $t('dashboard.select_board') }}
           </h1>
           <div v-if="!currentBoard && boards.length > 0">
              <span class="text-gray-500">{{ $t('dashboard.pick_board_msg') }}</span>
              <div class="mt-2 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                 <div v-for="board in boards" :key="board.id" @click="selectBoard(board.id)" class="bg-white dark:bg-gray-800 overflow-hidden shadow rounded-lg cursor-pointer hover:shadow-md transition">
                    <div class="px-4 py-5 sm:p-6">
                      <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">{{ board.title }}</h3>
                    </div>
                 </div>
              </div>
           </div>
        </div>

        <!-- Kanban Board Component -->
        <BoardDetail v-if="currentBoard" :board="currentBoard" @refresh="fetchBoardDetails" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
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

const fetchBoardDetails = async () => {
   if (currentBoard.value) {
      await selectBoard(currentBoard.value.id);
   }
}

onMounted(() => {
  fetchBoards();
});
</script>
