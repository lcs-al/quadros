<template>
 <div class="min-h-screen bg-transparent">
    <div class="mx-auto py-6 sm:px-6 lg:px-8">
      <Transition name="slide-up" appear>
        <div class="mb-12">
          <h1 class="text-4xl font-extrabold text-white mb-3 tracking-tight">
            {{ $t('dashboard.select_board') }}
          </h1>
          <p class="text-gray-400 text-lg max-w-2xl">
            {{ $t('dashboard.pick_board_msg') }}
          </p>
        </div>
      </Transition>

      <Transition name="fade" mode="out-in">
        <div v-if="loading && boards.length === 0" class="flex flex-col items-center justify-center mt-20 space-y-4">
          <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-500" />
          <p class="text-gray-500 animate-pulse">{{ $t('dashboard.loading') }}</p>
        </div>
        
        <div v-else class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
          
          <!-- Create New Board Card -->
          <Transition name="slide-up" appear>
            <div 
              class="group relative overflow-hidden rounded-3xl cursor-pointer transition-all duration-500 hover:shadow-2xl hover:shadow-indigo-500/20 hover:-translate-y-2 h-[420px]"
              @click="openCreateBoardModal"
            >
              <!-- Gradient Border Effect -->
              <div class="absolute inset-0 bg-gradient-to-br from-violet-600 via-blue-500 to-emerald-400 opacity-50 transition-opacity duration-500 group-hover:opacity-100 p-[2px] rounded-3xl">
                <!-- Glass Background -->
                <div class="absolute inset-[2px] bg-[#0F111A]/90 backdrop-blur-xl rounded-[22px] z-10"></div>
              </div>

              <!-- Content -->
              <div class="relative z-20 h-full p-8 flex flex-col justify-between">
                <div>
                  <div class="flex justify-between items-start">
                    <div class="w-full h-48 relative flex items-center justify-center">
                      <!-- 3D Illustration -->
                      <img 
                        :src="newBoardIllustration" 
                        alt="New Board" 
                        class="w-50 h-50 object-contain duration-700 group-hover:scale-110 group-hover:rotate-3 animate-float"
                      />
                      <!-- Glow behind image -->
                      <div class="absolute inset-0 bg-indigo-500/20 blur-[60px] rounded-full transform scale-75"></div>
                    </div>
                  </div>
                  
                  <h2 class="text-2xl font-bold text-white mb-2 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-white group-hover:to-gray-300 transition-all">
                    Começar um novo quadro
                  </h2>
                  <p class="text-gray-400 text-sm leading-relaxed">
                    Organize seus projetos com listas claras, sprints ágeis e fluxos de trabalho eficientes.
                  </p>
                </div>

                <button class="cursor-pointer w-full py-4 mt-6 rounded-xl bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-bold text-lg shadow-lg shadow-indigo-500/30 transition-all duration-300 hover:shadow-indigo-500/50 hover:brightness-110 flex items-center justify-center gap-2 group-hover:tracking-wide">
                  <font-awesome-icon icon="plus" class="text-sm" />
                  <span>{{ $t('board.create') }}</span>
                </button>
              </div>
            </div>
          </Transition>

          <!-- Existing Board Cards -->
          <div 
            v-for="(board, index) in boards" 
            :key="board.id"
            class="group relative h-[420px]"
            :style="{ animationDelay: `${index * 100}ms` }"
          >
            <div 
              @click="navigateToBoard(board.id)"
              class="relative h-full bg-[#1A1D26] hover:bg-[#202430] border border-gray-800 hover:border-indigo-500/30 rounded-3xl p-8 transition-all duration-300 cursor-pointer overflow-hidden shadow-xl hover:shadow-indigo-900/10 hover:-translate-y-2 flex flex-col"
            >
              <!-- Top Metadata -->
              <div class="relative flex justify-between items-start mb-8 z-10">
                <div class="p-3 rounded-2xl bg-[#0F111A] border border-gray-800 group-hover:border-indigo-500/30 group-hover:shadow-indigo-500/10 transition-all">
                   <img 
                    :src="boardIcon" 
                    alt="Board Icon" 
                    class="w-20 h-20 object-contain opacity-80 group-hover:opacity-100 transition-opacity"
                  />
                </div>

                <span 
                  v-if="board.created_by?.id === authStore.user?.id"
                  class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest bg-indigo-500/10 text-indigo-400 border border-indigo-500/20 shadow-[0_0_10px_rgba(99,102,241,0.2)]"
                >
                  {{ $t('board.access.owned') }}
                </span>
                <span 
                  v-else
                  class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
                >
                  {{ $t('board.access.shared') }}
                </span>
              </div>

              <!-- Main Content -->
              <div class="relative z-10 flex-1">
                <h3 class="text-3xl font-bold text-white mb-2 leading-tight group-hover:text-indigo-300 transition-colors line-clamp-2">
                  {{ board.title }}
                </h3>
                <div class="flex items-center text-gray-500 text-xs font-medium space-x-2 mt-4">
                   <font-awesome-icon icon="folder-open" />
                   <span>{{ $t('board.updated') }} {{ formatDate(board.updated_at) }}</span>
                </div>
              </div>

              <!-- Footer / 3D Element -->
              <div class="relative z-10 mt-auto pt-6 border-t border-gray-800/50 flex items-center justify-between">
                 <div class="flex items-center space-x-3">
                    <UserAvatar 
                      v-if="board.created_by" 
                      :user="board.created_by" 
                      size="sm"
                      class="ring-2 ring-[#1A1D26]" 
                    />
                    <div class="flex flex-col">
                      <span class="text-xs text-gray-400">Created by</span>
                      <span class="text-sm text-gray-200 font-medium">{{ board.created_by?.name }}</span>
                    </div>
                 </div>

                 <!-- Hover Action Indicator -->
                 <div class="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center text-gray-400 group-hover:bg-indigo-600 group-hover:text-white transition-all transform group-hover:scale-110">
                    <font-awesome-icon icon="arrow-right" />
                 </div>
              </div>

              <!-- Delete Button (Top Right) -->
              <button
                v-if="board.created_by?.id === authStore.user?.id"
                @click.stop="confirmDeleteBoard(board.id)"
                class="absolute top-6 right-6 p-3 rounded-xl text-gray-500 hover:text-red-400 hover:bg-red-500/10 transition-all opacity-0 group-hover:opacity-100 z-40"
                :title="$t('board.delete')"
              >
                <font-awesome-icon icon="trash-alt" />
              </button>
            </div>
          </div>

        </div>
      </Transition>
    </div>

    <!-- Modals (keeping existing logic) -->
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

// Assets
import newBoardIllustration from '../assets/new_board_illustration.png';
import boardIcon from '../assets/board_icon_3d.png';

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

const formatDate = (dateString) => {
    if (!dateString) return '';
    // Format: "há 4 minutos" or date
    // Simple relative implementation or standard date
    // Using simple logic for now
    const date = new Date(dateString);
    const now = new Date();
    const diff = (now - date) / 1000;
    
    if (diff < 60) return 'agora mesmo';
    if (diff < 3600) return `há ${Math.floor(diff/60)} minutos`;
    if (diff < 86400) return `há ${Math.floor(diff/3600)} horas`;
    return date.toLocaleDateString();
};

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
    // Optional: Auto navigate to new board
    // navigateToBoard(response.data.id); 
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

<style scoped>
.animate-float {
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-10px) rotate(1deg); }
  100% { transform: translateY(0px) rotate(0deg); }
}

/* Custom scrollbar for better blend */
::-webkit-scrollbar {
  width: 8px;
}
::-webkit-scrollbar-track {
  background: transparent;
}
::-webkit-scrollbar-thumb {
  background: #374151;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: #4B5563;
}
</style>
