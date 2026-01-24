<template>
  <div class="min-h-screen bg-transparent">
    <div class="mx-auto py-6 sm:px-6 lg:px-8">
      <div v-if="loading" class="flex flex-col items-center justify-center mt-20 space-y-4">
        <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-600" />
        <p class="text-gray-500 animate-pulse-subtle">{{ $t('dashboard.loading') }}</p>
      </div>
      <div v-else-if="board" class="space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <button
              @click="backToBoard"
              class="p-2 rounded-lg text-gray-500 hover:text-indigo-600 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 dark:text-gray-400 dark:hover:text-indigo-400 transition-all"
              :title="$t('board.back_to_boards')"
            >
              <font-awesome-icon icon="arrow-left" class="h-5 w-5" />
            </button>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ $t('board.backlog.title') }}: {{ board.title }}
            </h1>
          </div>
          
          <BaseButton @click="openAddCardModal" size="sm" class="flex items-center space-x-2">
            <font-awesome-icon icon="plus" class="h-4 w-4" />
            <span>{{ $t('card.add') }}</span>
          </BaseButton>
        </div>

        <!-- Backlog Cards List -->
        <div class="bg-white dark:bg-[#1A1D26] rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
          <div v-if="backlog && backlog.cards.length === 0" class="p-12 text-center space-y-4">
            <font-awesome-icon icon="clipboard-list" class="text-5xl text-gray-300 dark:text-gray-600" />
            <p class="text-gray-500 dark:text-gray-400">{{ $t('board.backlog.empty') }}</p>
            <BaseButton variant="secondary" @click="openAddCardModal" size="sm">
              {{ $t('card.add') }}
            </BaseButton>
          </div>
          <div v-else class="divide-y divide-gray-100 dark:divide-gray-700">
            <!-- Select All Row -->
            <div class="p-4 bg-gray-50/50 dark:bg-[#1A1D26]/50 flex items-center space-x-4 border-b border-gray-100 dark:border-gray-700">
              <input 
                type="checkbox" 
                :checked="isAllSelected" 
                @change="toggleSelectAll"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 h-4 w-4"
              />
              <span class="text-xs font-bold text-gray-400 uppercase tracking-widest">{{ $t('common.select_all') || 'Select All' }}</span>
            </div>

            <div v-for="card in backlog.cards" :key="card.id" 
                 class="p-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors flex items-center justify-between group">
              <div class="flex items-center space-x-4 flex-1">
                <input 
                  type="checkbox" 
                  :checked="selectedCards.has(card.id)" 
                  @change="toggleCardSelection(card.id)"
                  class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 h-4 w-4"
                />
                
                <div class="flex items-center space-x-4 flex-1 cursor-pointer" @click="openCardDetail(card)">
                  <div class="w-2 h-10 rounded-full" :class="getCardBorderColorClass(card.card_type)"></div>
                  <div>
                    <div class="flex items-center space-x-2 mb-1">
                      <font-awesome-icon :icon="getCardIcon(card.card_type)" class="text-xs opacity-70" :class="getCardIconColor(card.card_type)" />
                      <span class="text-[10px] uppercase font-bold tracking-wider opacity-60" :class="getCardIconColor(card.card_type)">
                        {{ $t(`card.types.${card.card_type || 'task'}`) }}
                      </span>
                    </div>
                    <h3 class="font-medium text-gray-900 dark:text-white">{{ card.title }}</h3>
                    <p v-if="card.description" class="text-sm text-gray-500 dark:text-gray-400 line-clamp-1 mt-0.5">{{ card.description }}</p>
                  </div>
                </div>
              </div>
              
              <div class="flex items-center space-x-3">
                <div v-if="card.assignee" class="flex items-center space-x-2 mr-4">
                  <UserAvatar :user="card.assignee" size="xs" />
                  <span class="text-xs text-gray-400">{{ card.assignee.name }}</span>
                </div>
                
                <BaseButton v-if="firstColumnId" variant="ghost" size="sm" @click="moveTooltipToBoard(card)" 
                            class="opacity-0 group-hover:opacity-100 transition-opacity flex items-center space-x-2 text-indigo-600 dark:text-indigo-400">
                  <font-awesome-icon icon="arrow-right" class="h-3 w-3" />
                  <span>{{ $t('board.backlog.move_to_board') }}</span>
                </BaseButton>
                
                <button @click="confirmDeleteCard(card)" class="p-2 text-gray-400 hover:text-red-500 transition-colors opacity-0 group-hover:opacity-100">
                  <font-awesome-icon icon="trash-alt" class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bulk Action Bar -->
    <Transition name="slide-up">
      <div v-if="selectedCards.size > 0" 
           class="fixed bottom-8 left-1/2 -translate-x-1/2 bg-white dark:bg-[#1A1D26] shadow-2xl rounded-full px-6 py-4 flex items-center space-x-8 border border-gray-100 dark:border-gray-700 z-[100] min-w-[400px]">
        <div class="flex items-center space-x-4 pr-8 border-r border-gray-100 dark:border-gray-700">
          <div class="bg-indigo-600 text-white text-xs font-bold px-2 py-1 rounded-full min-w-[24px] text-center">
            {{ selectedCards.size }}
          </div>
          <span class="text-sm font-semibold text-gray-700 dark:text-gray-200">
            {{ $t('board.backlog.selected_count', { count: selectedCards.size }) }}
          </span>
        </div>
        
        <div class="flex items-center space-x-3">
          <BaseButton 
            v-if="firstColumnId"
            size="sm" 
            :loading="bulkLoading"
            @click="submitBulkMoveToBoard"
            class="flex items-center space-x-2"
          >
            <font-awesome-icon icon="arrow-right" class="h-4 w-4" />
            <span>{{ $t('board.backlog.move_to_board') }}</span>
          </BaseButton>
          
          <button 
            @click="selectedCards.clear()"
            class="text-xs font-bold text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 uppercase tracking-widest transition-colors"
          >
            {{ $t('common.cancel') }}
          </button>
        </div>
      </div>
    </Transition>

    <!-- Modals (Re-using some logic/structure from BoardDetail) -->
    <BaseModal :isOpen="modalState.addCard.isOpen" :title="$t('card.add')" @close="modalState.addCard.isOpen = false">
      <form @submit.prevent="submitAddCard" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">{{ $t('card.title') }}</label>
          <input v-model="modalState.addCard.title" type="text" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500" required autofocus />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">{{ $t('card.type') }}</label>
          <div class="flex space-x-4">
            <label v-for="type in ['story', 'task', 'bug']" :key="type" class="flex items-center space-x-2 cursor-pointer">
              <input type="radio" v-model="modalState.addCard.card_type" :value="type" class="text-indigo-600 focus:ring-indigo-500" />
              <span class="text-sm text-gray-700 dark:text-gray-300">
                <font-awesome-icon :icon="getCardIcon(type)" class="mr-1" :class="getCardIconColor(type)" />
                {{ $t(`card.types.${type}`) }}
              </span>
            </label>
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">{{ $t('card.description') }}</label>
          <textarea v-model="modalState.addCard.description" rows="3" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500" :placeholder="$t('card.description_placeholder')"></textarea>
        </div>
        <div class="flex justify-end space-x-3 pt-2">
          <BaseButton variant="secondary" @click="modalState.addCard.isOpen = false">{{ $t('common.cancel') }}</BaseButton>
          <BaseButton type="submit" :loading="modalState.addCard.loading">{{ $t('common.save') }}</BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Card Detail Modal (Simplified for now, could be refactored into a separate component) -->
    <BaseModal :isOpen="modalState.cardDetail.isOpen" :title="modalState.cardDetail.data?.title || $t('card.title')" @close="modalState.cardDetail.isOpen = false">
        <div v-if="modalState.cardDetail.data" class="space-y-6">
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">{{ $t('card.description') }}</label>
                <textarea v-model="modalState.cardDetail.editData.description" rows="6" @blur="saveCardEdit" class="w-full px-4 py-3 bg-gray-50/50 dark:bg-gray-700/30 border border-transparent rounded-xl focus:border-indigo-500 focus:outline-none transition-all text-gray-700 dark:text-gray-200 text-sm" :placeholder="$t('card.description_placeholder')"></textarea>
            </div>
            <div class="flex justify-between items-center bg-gray-50 dark:bg-[#1A1D26] p-4 rounded-xl">
                 <div v-if="modalState.cardDetail.data.creator" class="text-xs text-gray-500">
                     {{ $t('card.metadata.creator') }}: {{ modalState.cardDetail.data.creator.name }}
                 </div>
                 <BaseButton variant="danger" size="sm" @click="confirmDeleteCard(modalState.cardDetail.data)">
                     <font-awesome-icon icon="trash-alt" class="mr-2" />
                     {{ $t('card.delete') }}
                 </BaseButton>
            </div>
        </div>
    </BaseModal>

    <!-- Delete Confirm -->
    <BaseModal :isOpen="modalState.deleteCard.isOpen" :title="$t('common.confirm_delete')" @close="modalState.deleteCard.isOpen = false">
      <p class="text-gray-600 dark:text-gray-400 mb-6">{{ $t('card.delete_confirm') }}</p>
      <div class="flex justify-end space-x-3">
        <BaseButton variant="secondary" @click="modalState.deleteCard.isOpen = false">{{ $t('common.cancel') }}</BaseButton>
        <BaseButton variant="danger" :loading="modalState.deleteCard.loading" @click="submitDeleteCard">{{ $t('common.delete') }}</BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import api from '../api';
import BaseButton from '../components/common/BaseButton.vue';
import BaseModal from '../components/common/BaseModal.vue';
import UserAvatar from '../components/common/UserAvatar.vue';
import { useAuthStore } from '../stores/auth';
import { useUIStore } from '../stores/ui';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const uiStore = useUIStore();
const { t } = useI18n();

const board = ref(null);
const backlog = ref(null);
const loading = ref(true);
const bulkLoading = ref(false);
const selectedCards = ref(new Set());

const isAllSelected = computed(() => {
  return backlog.value?.cards?.length > 0 && selectedCards.value.size === backlog.value.cards.length;
});

const toggleCardSelection = (cardId) => {
  if (selectedCards.value.has(cardId)) {
    selectedCards.value.delete(cardId);
  } else {
    selectedCards.value.add(cardId);
  }
};

const toggleSelectAll = () => {
  if (isAllSelected.value) {
    selectedCards.value.clear();
  } else {
    backlog.value.cards.forEach(card => selectedCards.value.add(card.id));
  }
};

const modalState = reactive({
  addCard: { isOpen: false, title: '', description: '', card_type: 'task', loading: false },
  cardDetail: { isOpen: false, data: null, editData: { title: '', description: '' }, loading: false },
  deleteCard: { isOpen: false, cardId: null, loading: false }
});

const firstColumnId = computed(() => board.value?.columns?.[0]?.id);

const fetchBacklog = async () => {
  loading.value = true;
  try {
    const [boardRes, backlogRes] = await Promise.all([
      api.get(`/boards/${route.params.id}`),
      api.get(`/boards/${route.params.id}/backlog`)
    ]);
    board.value = boardRes.data;
    backlog.value = backlogRes.data;
  } catch (error) {
    console.error('Failed to fetch backlog', error);
    router.push({ name: 'BoardsList' });
  } finally {
    loading.value = false;
  }
};

const backToBoard = () => {
  router.push({ name: 'BoardEdit', params: { id: board.value.id } });
};

const openAddCardModal = () => {
  modalState.addCard.title = '';
  modalState.addCard.description = '';
  modalState.addCard.card_type = 'task';
  modalState.addCard.isOpen = true;
};

const submitAddCard = async () => {
    if (!modalState.addCard.title) return;
    modalState.addCard.loading = true;
    try {
        await api.post('/cards', {
            title: modalState.addCard.title,
            description: modalState.addCard.description,
            card_type: modalState.addCard.card_type,
            backlog_id: backlog.value.id,
            assignee_id: authStore.user.id
        });
        modalState.addCard.isOpen = false;
        fetchBacklog();
    } catch (error) {
        console.error('Create card failed', error);
    } finally {
        modalState.addCard.loading = false;
    }
};

const openCardDetail = (card) => {
    modalState.cardDetail.data = card;
    modalState.cardDetail.editData.title = card.title;
    modalState.cardDetail.editData.description = card.description || '';
    modalState.cardDetail.isOpen = true;
};

const saveCardEdit = async () => {
    const { data, editData } = modalState.cardDetail;
    if (!data || (data.title === editData.title && data.description === editData.description)) return;
    
    try {
        await api.patch(`/cards/${data.id}`, {
            title: editData.title,
            description: editData.description
        });
        fetchBacklog();
    } catch (error) {
        console.error('Update card failed', error);
    }
};

const moveTooltipToBoard = async (card) => {
    if (!firstColumnId.value) return;
    try {
        await api.patch(`/cards/${card.id}/move`, {
            column_id: firstColumnId.value,
            position: 1
        });
        fetchBacklog();
    } catch (error) {
        console.error('Move card to board failed', error);
    }
};

const confirmDeleteCard = (card) => {
    modalState.deleteCard.cardId = card.id;
    modalState.deleteCard.isOpen = true;
};

const submitDeleteCard = async () => {
    modalState.deleteCard.loading = true;
    try {
        await api.delete(`/cards/${modalState.deleteCard.cardId}`);
        modalState.deleteCard.isOpen = false;
        modalState.cardDetail.isOpen = false;
        fetchBacklog();
    } catch (error) {
        console.error('Delete card failed', error);
    } finally {
        modalState.deleteCard.loading = false;
    }
};

const submitBulkMoveToBoard = async () => {
    if (selectedCards.value.size === 0 || !firstColumnId.value) return;
    
    bulkLoading.value = true;
    try {
        await api.post('/cards/bulk_move', {
            card_ids: Array.from(selectedCards.value),
            column_id: firstColumnId.value,
            position: 1
        });
        
        uiStore.addNotification({
            type: 'success',
            message: t('board.backlog.bulk_move_success')
        });
        
        selectedCards.value.clear();
        fetchBacklog();
    } catch (error) {
        console.error('Bulk move failed', error);
        uiStore.addNotification({
            type: 'error',
            message: error.response?.data?.error || 'Bulk move failed'
        });
    } finally {
        bulkLoading.value = false;
    }
};

// UI Helpers (could be shared later)
const getCardIcon = (type) => {
  switch (type) {
    case "story": return "bookmark";
    case "bug": return "bug";
    default: return "check-square";
  }
};

const getCardIconColor = (type) => {
  switch (type) {
    case "story": return "text-green-500";
    case "bug": return "text-red-500";
    default: return "text-blue-500";
  }
};

const getCardBorderColorClass = (type) => {
  switch (type) {
    case 'story': return 'bg-green-500';
    case 'bug': return 'bg-red-500';
    default: return 'bg-blue-500';
  }
};

onMounted(fetchBacklog);
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  line-clamp: 1;
  -webkit-box-orient: vertical;  
  overflow: hidden;
}
</style>
