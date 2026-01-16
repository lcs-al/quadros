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
                     <font-awesome-icon icon="plus" class="h-4 w-4" />
                  </button>
                  <!-- Delete Column (Admin only or Creator) -->
                   <button v-if="authStore.isAdmin" @click="deleteColumn(column.id)" class="text-red-500 hover:text-red-700">
                      <font-awesome-icon icon="trash-alt" class="h-4 w-4" />
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
                   <div 
                     @click="openCardDetail(card)"
                     class="bg-white dark:bg-gray-600 p-3 rounded shadow cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-500 text-left border-l-4 border-indigo-400 group"
                   >
                       <div class="font-medium text-gray-900 dark:text-white group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">{{ card.title }}</div>
                       <div class="text-sm text-gray-500 dark:text-gray-300 mt-1 line-clamp-2" v-if="card.description">{{ card.description }}</div>
                       <!-- Assignee Avatar -->
                        <div class="mt-2 flex items-center justify-between">
                           <div v-if="card.assignee" class="flex items-center">
                              <span class="inline-flex items-center justify-center h-6 w-6 rounded-full bg-indigo-500" :title="card.assignee.name">
                                <span class="text-xs font-medium leading-none text-white">{{ card.assignee.name.charAt(0) }}</span>
                              </span>
                              <span class="text-[10px] text-gray-400 ml-2">{{ card.assignee.name }}</span>
                           </div>
                           <div class="flex items-center space-x-2 text-gray-400">
                             <font-awesome-icon v-if="card.description" icon="align-left" class="text-[10px]" />
                           </div>
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
            <font-awesome-icon icon="plus" class="h-5 w-5 mr-2" />
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
            {{ $t('common.cancel') }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addColumn.loading">
            {{ $t('common.save') }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Add Card Modal -->
    <BaseModal 
      :isOpen="modalState.addCard.isOpen" 
      :title="$t('card.add')" 
      @close="modalState.addCard.isOpen = false"
    >
      <form @submit.prevent="submitAddCard" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            {{ $t('card.title') }}
          </label>
          <input 
            v-model="modalState.addCard.title"
            type="text" 
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500"
            required
            autofocus
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            {{ $t('card.description') }}
          </label>
          <textarea 
            v-model="modalState.addCard.description"
            rows="3"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500"
            :placeholder="$t('card.description_placeholder')"
          ></textarea>
        </div>
        <div class="flex justify-end space-x-3 pt-2">
          <BaseButton variant="secondary" @click="modalState.addCard.isOpen = false">
            {{ $t('common.cancel') }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addCard.loading">
            {{ $t('common.save') }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Card Detail Modal -->
    <BaseModal 
      :isOpen="modalState.cardDetail.isOpen" 
      :title="modalState.cardDetail.data?.title || $t('card.title')" 
      @close="closeCardDetail"
    >
      <div v-if="modalState.cardDetail.loading" class="flex justify-center py-12">
        <font-awesome-icon icon="spinner" spin class="text-3xl text-indigo-600" />
      </div>
      <div v-else-if="modalState.cardDetail.data" class="space-y-6">
        <!-- Title & Description Editing -->
        <div class="space-y-4">
          <div>
            <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
              {{ $t('card.title') }}
            </label>
            <input 
              v-model="modalState.cardDetail.editData.title"
              type="text" 
              @blur="submitEditCard"
              class="w-full text-xl font-bold bg-transparent border-b-2 border-transparent hover:border-gray-200 dark:hover:border-gray-600 focus:border-indigo-500 dark:focus:border-indigo-400 focus:outline-none py-1 transition-all text-gray-900 dark:text-white"
            />
          </div>

          <div>
            <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">
              {{ $t('card.description') }}
            </label>
            <textarea 
              v-model="modalState.cardDetail.editData.description"
              rows="4"
              @blur="submitEditCard"
              class="w-full px-3 py-2 bg-gray-50 dark:bg-gray-700/50 border border-transparent rounded-lg focus:border-indigo-500 dark:focus:border-indigo-400 focus:bg-white dark:focus:bg-gray-700 focus:outline-none transition-all text-gray-700 dark:text-gray-200"
              :placeholder="$t('card.description_placeholder')"
            ></textarea>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-6 py-4 border-y border-gray-100 dark:border-gray-700">
          <div class="space-y-3">
             <div>
                <span class="block text-xs font-bold text-gray-400 uppercase tracking-wider">{{ $t('card.metadata.creator') }}</span>
                <span class="text-sm text-gray-700 dark:text-gray-300 flex items-center mt-1">
                  <span class="h-6 w-6 rounded-full bg-slate-500 flex items-center justify-center text-[10px] mr-2 text-white">
                    {{ modalState.cardDetail.data.creator?.name?.charAt(0) || '?' }}
                  </span>
                  {{ modalState.cardDetail.data.creator?.name || $t('card.metadata.unknown') }}
                </span>
             </div>
             <div>
                <span class="block text-xs font-bold text-gray-400 uppercase tracking-wider">{{ $t('card.metadata.assignee') }}</span>
                <span class="text-sm text-gray-700 dark:text-gray-300 flex items-center mt-1">
                  <span class="h-6 w-6 rounded-full bg-indigo-500 flex items-center justify-center text-[10px] mr-2 text-white">
                    {{ modalState.cardDetail.data.assignee?.name?.charAt(0) || '?' }}
                  </span>
                  {{ modalState.cardDetail.data.assignee?.name || $t('card.metadata.unassigned') }}
                </span>
             </div>
          </div>
          <div class="space-y-3">
             <div>
                <span class="block text-xs font-bold text-gray-400 uppercase tracking-wider">{{ $t('card.metadata.created_at') }}</span>
                <span class="text-sm text-gray-600 dark:text-gray-400 block mt-1">
                   {{ formatDate(modalState.cardDetail.data.created_at) }}
                </span>
             </div>
             <div class="pt-2">
                <BaseButton 
                  variant="ghost" 
                  size="sm" 
                  class="text-red-500 hover:text-red-700 hover:bg-red-50 dark:hover:bg-red-900/20 w-full justify-start px-0"
                  @click="confirmDeleteCard"
                >
                  <font-awesome-icon icon="trash-alt" class="mr-2" />
                  {{ $t('card.delete') }}
                </BaseButton>
             </div>
          </div>
        </div>

        <!-- Comments Section -->
        <div class="space-y-4">
           <h4 class="text-sm font-bold text-gray-900 dark:text-white flex items-center">
             <font-awesome-icon icon="comment" class="mr-2 text-gray-400" />
             {{ $t('card.comments.title') }}
           </h4>
           
           <!-- Comment List -->
           <div class="space-y-4 max-h-60 overflow-y-auto pr-2 scrollbar-thin">
              <div v-for="comment in modalState.cardDetail.data.comments" :key="comment.id" class="flex space-x-3">
                 <div class="flex-shrink-0">
                    <div class="h-8 w-8 rounded-full bg-gray-400 flex items-center justify-center text-xs text-white">
                       {{ comment.user?.name?.charAt(0) || '?' }}
                    </div>
                 </div>
                 <div class="bg-gray-50 dark:bg-gray-700/30 p-3 rounded-lg flex-1">
                    <div class="flex justify-between items-center mb-1">
                       <span class="text-xs font-bold text-gray-900 dark:text-white">{{ comment.user?.name }}</span>
                       <span class="text-[10px] text-gray-500">{{ formatDate(comment.created_at) }}</span>
                    </div>
                    <p class="text-sm text-gray-700 dark:text-gray-300">{{ comment.content }}</p>
                 </div>
              </div>
           </div>

           <!-- Add Comment -->
           <div class="flex space-x-3 mt-4">
              <div class="flex-shrink-0">
                 <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-xs text-white">
                    {{ authStore.user?.name?.charAt(0) }}
                 </div>
              </div>
              <div class="flex-1 space-y-2">
                 <textarea 
                   v-model="modalState.cardDetail.newComment"
                   @keydown.enter.prevent="submitAddComment"
                   rows="2"
                   class="w-full px-3 py-2 border border-gray-200 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                   :placeholder="$t('card.comments.placeholder')"
                 ></textarea>
                 <div class="flex justify-end">
                    <BaseButton 
                      size="sm" 
                      :loading="modalState.cardDetail.commentLoading" 
                      @click="submitAddComment"
                      :disabled="!modalState.cardDetail.newComment.trim()"
                    >
                      {{ $t('card.comments.post') }}
                    </BaseButton>
                 </div>
              </div>
           </div>
        </div>
      </div>
    </BaseModal>

    <!-- Delete Column Confirm Modal -->
    <BaseModal 
      :isOpen="modalState.deleteColumn.isOpen" 
      :title="$t('board.column.delete_confirm_title')" 
      @close="modalState.deleteColumn.isOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t('board.column.delete_confirm_body') }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton variant="secondary" @click="modalState.deleteColumn.isOpen = false">
          {{ $t('common.cancel') }}
        </BaseButton>
        <BaseButton variant="danger" :loading="modalState.deleteColumn.loading" @click="submitDeleteColumn">
          {{ $t('common.confirm_delete') }}
        </BaseButton>
      </div>
    </BaseModal>

    <!-- Delete Card Confirm Modal -->
    <BaseModal 
      :isOpen="modalState.deleteCard.isOpen" 
      :title="$t('common.confirm_delete')" 
      @close="modalState.deleteCard.isOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t('card.delete_confirm') }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton variant="secondary" @click="modalState.deleteCard.isOpen = false">
          {{ $t('common.cancel') }}
        </BaseButton>
        <BaseButton variant="danger" :loading="modalState.deleteCard.loading" @click="submitDeleteCard">
          {{ $t('common.delete') }}
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
    addCard: { isOpen: false, title: '', description: '', columnId: null, loading: false },
    deleteColumn: { isOpen: false, columnId: null, loading: false },
    cardDetail: { 
      isOpen: false, 
      loading: false, 
      data: null, 
      editData: { title: '', description: '' },
      newComment: '',
      commentLoading: false
    },
    deleteCard: { isOpen: false, cardId: null, loading: false }
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
    modalState.addCard.description = '';
    modalState.addCard.isOpen = true;
};

const submitAddCard = async () => {
    if (!modalState.addCard.title) return;
    modalState.addCard.loading = true;
    try {
        await api.post(`/cards`, {
            title: modalState.addCard.title,
            description: modalState.addCard.description,
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

const openCardDetail = async (card) => {
    modalState.cardDetail.isOpen = true;
    modalState.cardDetail.loading = true;
    try {
        const response = await api.get(`/cards/${card.id}`);
        modalState.cardDetail.data = response.data;
        modalState.cardDetail.editData.title = response.data.title;
        modalState.cardDetail.editData.description = response.data.description || '';
    } catch (error) {
        console.error("Fetch card details failed", error);
        modalState.cardDetail.isOpen = false;
    } finally {
        modalState.cardDetail.loading = false;
    }
};

const closeCardDetail = () => {
    modalState.cardDetail.isOpen = false;
    modalState.cardDetail.data = null;
    modalState.cardDetail.newComment = '';
};

const submitEditCard = async () => {
    const { data, editData } = modalState.cardDetail;
    if (!data || !editData.title) return;
    
    // Only update if changed
    if (data.title === editData.title && data.description === editData.description) return;

    try {
        const response = await api.patch(`/cards/${data.id}`, {
            title: editData.title,
            description: editData.description
        });
        modalState.cardDetail.data = { ...data, ...response.data };
        emit('refresh');
    } catch (error) {
        console.error("Update card failed", error);
    }
};

const submitAddComment = async () => {
    const { data, newComment } = modalState.cardDetail;
    if (!data || !newComment.trim()) return;

    modalState.cardDetail.commentLoading = true;
    try {
        const response = await api.post(`/cards/${data.id}/comments`, {
            content: newComment
        });
        // Append comment with user info (current user)
        const commentWithUser = { ...response.data, user: authStore.user };
        modalState.cardDetail.data.comments.push(commentWithUser);
        modalState.cardDetail.newComment = '';
    } catch (error) {
        console.error("Add comment failed", error);
    } finally {
        modalState.cardDetail.commentLoading = false;
    }
};

const confirmDeleteCard = () => {
    modalState.deleteCard.cardId = modalState.cardDetail.data.id;
    modalState.deleteCard.isOpen = true;
};

const submitDeleteCard = async () => {
    const cardId = modalState.deleteCard.cardId;
    modalState.deleteCard.loading = true;
    try {
        await api.delete(`/cards/${cardId}`);
        modalState.deleteCard.isOpen = false;
        closeCardDetail();
        emit('refresh');
        
        // Add undo notification
        uiStore.addNotification({
            type: 'info',
            message: t('card.delete_success') || 'Card deleted',
            action: {
                label: t('common.undo'),
                callback: () => submitRestoreCard(cardId)
            }
        });
    } catch (error) {
        console.error("Delete card failed", error);
    } finally {
        modalState.deleteCard.loading = false;
    }
};

const submitRestoreCard = async (cardId) => {
    try {
        await api.post(`/cards/${cardId}/restore`);
        emit('refresh');
        uiStore.addNotification({
            type: 'success',
            message: t('card.restore_success')
        });
    } catch (error) {
        console.error("Restore card failed", error);
    }
};

const formatDate = (dateString) => {
    if (!dateString) return '';
    return new Date(dateString).toLocaleString();
}
</script>

