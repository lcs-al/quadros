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
       <button @click="openAddColumnModal" class="w-full py-2 border-2 border-dashed border-gray-400 dark:border-gray-600 rounded-md text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 font-medium">
          {{ $t('board.column.add') }}
       </button>
    </div>
  </div>
</template>

<script setup>
import { ref, watchEffect } from 'vue';
import draggable from 'vuedraggable';
import api from '../api';
import { useAuthStore } from '../stores/auth';
import { useI18n } from 'vue-i18n';

const props = defineProps(['board']);
const emit = defineEmits(['refresh']);
const authStore = useAuthStore();
const { t } = useI18n();
const columns = ref([]);

watchEffect(() => {
  if (props.board && props.board.columns) {
    columns.value = JSON.parse(JSON.stringify(props.board.columns));
  }
});

const onColumnDrop = async (evt) => {
   const columnId = columns.value[evt.newIndex].id;
   try {
     await api.patch(`/boards/${props.board.id}/columns/${columnId}/move`, {
       position: evt.newIndex + 1
     });
   } catch (error) {
     console.error("Move column failed", error);
     emit('refresh');
   }
};

const onCardChange = async (evt, columnId) => {
  if (evt.added) {
    const card = evt.added.element;
    const newIndex = evt.added.newIndex;
    try {
      await api.patch(`/cards/${card.id}/move`, {
        column_id: columnId,
        position: newIndex + 1
      });
    } catch (error) {
      console.error("Move card failed", error);
      emit('refresh');
    }
  } else if (evt.moved) {
    const card = evt.moved.element;
    const newIndex = evt.moved.newIndex;
    try {
      await api.patch(`/cards/${card.id}/move`, {
        position: newIndex + 1
      });
    } catch (error) {
      console.error("Reorder card failed", error);
      emit('refresh');
    }
  }
};

const openAddColumnModal = async () => {
    const title = prompt(t('board.column.prompt_title'));
    if (title) {
        try {
            await api.post(`/boards/${props.board.id}/columns`, {
                title: title
            });
            emit('refresh');
        } catch (error) {
            console.error("Create column failed", error);
        }
    }
}

const deleteColumn = async (columnId) => {
    if(confirm(t('board.column.delete_confirm'))) {
        try {
            await api.delete(`/boards/${props.board.id}/columns/${columnId}`);
            emit('refresh');
        } catch (error) {
             console.error("Delete column failed", error);
        }
    }
}

const openAddCardModal = async (column) => {
    const title = prompt(t('board.card.prompt_title'));
    if (title) {
        try {
            await api.post(`/cards`, {
                title: title,
                column_id: column.id,
                assignee_id: authStore.user.id // Default to self
            });
            emit('refresh');
        } catch (error) {
             console.error("Create card failed", error);
        }
    }
}
</script>

