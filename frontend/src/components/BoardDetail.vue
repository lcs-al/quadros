<template>
  <div class="flex overflow-x-auto h-[calc(100vh-10rem)] pb-4 items-start space-x-4">
    <!-- Columns -->
    <draggable 
      v-model="columns" 
      group="columns" 
      @end="onColumnDrop" 
      item-key="id"
      class="flex space-x-4 h-full"
      handle=".column-handle"
    >
      <template #item="{element: column}">
        <div class="flex-shrink-0 w-80 bg-gray-200 dark:bg-gray-800 rounded-md shadow-md flex flex-col max-h-full">
           <!-- Column Header -->
           <div class="p-3 flex justify-between items-center bg-gray-300 dark:bg-gray-700 rounded-t-md column-handle cursor-move">
              <h3 class="font-bold text-gray-700 dark:text-gray-200">{{ column.title }}</h3>
              <div class="flex space-x-1">
                 <!-- Add Card Button -->
                  <button @click="openAddCardModal(column)" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                       <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                  </button>
                  <!-- Delete Column (Admin only or Creator) -->
                   <button v-if="authStore.isAdmin" @click="deleteColumn(column.id)" class="text-red-500 hover:text-red-700">
                      <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                         <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                   </button>
              </div>
           </div>

           <!-- Cards List -->
           <div class="p-2 flex-1 overflow-y-auto min-h-0">
             <draggable 
                :list="column.cards" 
                group="cards" 
                item-key="id"
                class="space-y-3 min-h-[50px]"
                @change="(evt) => onCardChange(evt, column.id)"
             >
                <template #item="{element: card}">
                   <div class="bg-white dark:bg-gray-600 p-3 rounded shadow cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-500 text-left">
                      <div class="font-medium text-gray-900 dark:text-white">{{ card.title }}</div>
                      <div class="text-sm text-gray-500 dark:text-gray-300 mt-1 line-clamp-2" v-if="card.description">{{ card.description }}</div>
                      <!-- Assignee Avatar -->
                       <div v-if="card.assignee" class="mt-2 flex items-center justify-between">
                          <span class="inline-flex items-center justify-center h-6 w-6 rounded-full bg-indigo-500" :title="card.assignee.name">
                            <span class="text-xs font-medium leading-none text-white">{{ card.assignee.name.charAt(0) }}</span>
                          </span>
                       </div>
                   </div>
                </template>
             </draggable>
           </div>
        </div>
      </template>
    </draggable>

    <!-- New Column Button -->
    <div class="flex-shrink-0 w-80" v-if="authStore.isAdmin">
       <button @click="openAddColumnModal" class="w-full py-4 border-2 border-dashed border-gray-400 dark:border-gray-600 rounded-md text-gray-500 hover:text-indigo-600 hover:border-indigo-400 dark:text-gray-400 dark:hover:text-indigo-400 dark:hover:border-indigo-600 font-medium transition-all transform active:scale-[0.98]">
          <span class="flex items-center justify-center">
            <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            {{ $t('board.column.add') }}
          </span>
       </button>
    </div>

    <!-- Modals -->
    <!-- Add Column Modal -->
    <BaseModal 
      :isOpen="modalState.addColumn.isOpen" 
      :title="$t('board.column.add')" 
      @close="modalState.addColumn.isOpen = false"
    >
      <form @submit.prevent="submitAddColumn">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          {{ $t('board.column.prompt_title') }}
        </label>
        <input 
          v-model="modalState.addColumn.title"
          type="text" 
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 mb-4"
          required
          autofocus
        />
        <div class="flex justify-end space-x-3">
          <BaseButton variant="secondary" @click="modalState.addColumn.isOpen = false">
            {{ $t('common.cancel') || 'Cancel' }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addColumn.loading">
            {{ $t('common.save') || 'Save' }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Add Card Modal -->
    <BaseModal 
      :isOpen="modalState.addCard.isOpen" 
      :title="$t('board.card.add')" 
      @close="modalState.addCard.isOpen = false"
    >
      <form @submit.prevent="submitAddCard">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          {{ $t('board.card.prompt_title') }}
        </label>
        <input 
          v-model="modalState.addCard.title"
          type="text" 
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 mb-4"
          required
          autofocus
        />
        <div class="flex justify-end space-x-3">
          <BaseButton variant="secondary" @click="modalState.addCard.isOpen = false">
            {{ $t('common.cancel') || 'Cancel' }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addCard.loading">
            {{ $t('common.save') || 'Save' }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Delete Column Confirm Modal -->
    <BaseModal 
      :isOpen="modalState.deleteColumn.isOpen" 
      :title="$t('board.column.delete_confirm')" 
      @close="modalState.deleteColumn.isOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t('board.column.delete_confirm') }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton variant="secondary" @click="modalState.deleteColumn.isOpen = false">
          {{ $t('common.cancel') || 'Cancel' }}
        </BaseButton>
        <BaseButton variant="danger" :loading="modalState.deleteColumn.loading" @click="submitDeleteColumn">
          {{ $t('common.confirm_delete') || 'Delete' }}
        </BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup>
import { ref, watchEffect, reactive } from 'vue';
import draggable from 'vuedraggable';
import api from '../api';
import { useAuthStore } from '../stores/auth';
import { useUIStore } from '../stores/ui';
import { useI18n } from 'vue-i18n';
import BaseModal from './common/BaseModal.vue';
import BaseButton from './common/BaseButton.vue';

const props = defineProps(['board']);
const emit = defineEmits(['refresh']);
const authStore = useAuthStore();
const uiStore = useUIStore();
const { t } = useI18n();
const columns = ref([]);

// Modal States
const modalState = reactive({
    addColumn: { isOpen: false, title: '', loading: false },
    addCard: { isOpen: false, title: '', columnId: null, loading: false },
    deleteColumn: { isOpen: false, columnId: null, loading: false }
});

watchEffect(() => {
  if (props.board && props.board.columns) {
    columns.value = JSON.parse(JSON.stringify(props.board.columns));
  }
});

const onColumnDrop = async (evt) => {
   const columnId = columns.value[evt.newIndex].id;
   uiStore.setLoading(true);
   try {
     await api.patch(`/boards/${props.board.id}/columns/${columnId}/move`, {
       position: evt.newIndex + 1
     });
   } catch (error) {
     console.error("Move column failed", error);
     emit('refresh');
   } finally {
     uiStore.setLoading(false);
   }
};

const onCardChange = async (evt, columnId) => {
  if (evt.added || evt.moved) {
    uiStore.setLoading(true);
    const card = evt.added ? evt.added.element : evt.moved.element;
    const newIndex = evt.added ? evt.added.newIndex : evt.moved.newIndex;
    
    try {
      const payload = { position: newIndex + 1 };
      if (evt.added) payload.column_id = columnId;
      
      await api.patch(`/cards/${card.id}/move`, payload);
    } catch (error) {
      console.error("Move/Reorder card failed", error);
      emit('refresh');
    } finally {
      uiStore.setLoading(false);
    }
  }
};

const openAddColumnModal = () => {
    modalState.addColumn.title = '';
    modalState.addColumn.isOpen = true;
};

const submitAddColumn = async () => {
    if (!modalState.addColumn.title) return;
    modalState.addColumn.loading = true;
    try {
        await api.post(`/boards/${props.board.id}/columns`, {
            title: modalState.addColumn.title
        });
        modalState.addColumn.isOpen = false;
        emit('refresh');
    } catch (error) {
        console.error("Create column failed", error);
    } finally {
        modalState.addColumn.loading = false;
    }
};

const deleteColumn = (columnId) => {
    modalState.deleteColumn.columnId = columnId;
    modalState.deleteColumn.isOpen = true;
};

const submitDeleteColumn = async () => {
    modalState.deleteColumn.loading = true;
    try {
        await api.delete(`/boards/${props.board.id}/columns/${modalState.deleteColumn.columnId}`);
        modalState.deleteColumn.isOpen = false;
        emit('refresh');
    } catch (error) {
         console.error("Delete column failed", error);
    } finally {
        modalState.deleteColumn.loading = false;
    }
};

const openAddCardModal = (column) => {
    modalState.addCard.columnId = column.id;
    modalState.addCard.title = '';
    modalState.addCard.isOpen = true;
};

const submitAddCard = async () => {
    if (!modalState.addCard.title) return;
    modalState.addCard.loading = true;
    try {
        await api.post(`/cards`, {
            title: modalState.addCard.title,
            column_id: modalState.addCard.columnId,
            assignee_id: authStore.user.id
        });
        modalState.addCard.isOpen = false;
        emit('refresh');
    } catch (error) {
         console.error("Create card failed", error);
    } finally {
        modalState.addCard.loading = false;
    }
};
</script>

