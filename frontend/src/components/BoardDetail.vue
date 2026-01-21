<template>
  <div
    class="flex overflow-x-auto h-[calc(100vh-10rem)] pb-4 items-start space-x-4"
  >
    <!-- Columns -->
    <draggable
      v-model="columns"
      group="columns"
      @end="onColumnDrop"
      item-key="id"
      class="flex space-x-4 h-full"
      :handle="canEdit ? '.column-handle' : ''"
      :disabled="!canEdit"
    >
      <template #item="{ element: column }">
        <BoardColumn
          :column="column"
          :canEdit="canEdit"
          @add-card="openAddCardModal"
          @delete-column="deleteColumn"
          @card-click="openCardDetail"
          @card-change="onCardChange"
        />
      </template>
    </draggable>

    <!-- New Column Button -->
    <div class="flex-shrink-0 w-80" v-if="canEdit">
      <button
        @click="openAddColumnModal"
        class="w-full py-4 border-2 border-dashed border-gray-400 dark:border-gray-600 rounded-md text-gray-500 hover:text-indigo-600 hover:border-indigo-400 dark:text-gray-400 dark:hover:text-indigo-400 dark:hover:border-indigo-600 font-medium transition-all transform active:scale-[0.98]"
      >
        <span class="flex items-center justify-center">
          <font-awesome-icon icon="plus" class="h-5 w-5 mr-2" />
          {{ $t("board.column.add") }}
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
        <label
          class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
        >
          {{ $t("board.column.prompt_title") }}
        </label>
        <input
          v-model="modalState.addColumn.title"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500 mb-4"
          required
          autofocus
        />
        <div class="flex justify-end space-x-3">
          <BaseButton
            variant="secondary"
            @click="modalState.addColumn.isOpen = false"
          >
            {{ $t("common.cancel") }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addColumn.loading">
            {{ $t("common.save") }}
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
          <label
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
          >
            {{ $t("card.title") }}
          </label>
          <input
            v-model="modalState.addCard.title"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500"
            required
            autofocus
          />
        </div>

        <!-- Card Type Selection -->
        <div>
          <label
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2"
            >{{ $t("card.type") }}</label
          >
          <div class="flex space-x-4">
            <label class="flex items-center space-x-2 cursor-pointer">
              <input
                type="radio"
                v-model="modalState.addCard.card_type"
                value="story"
                class="text-green-500 focus:ring-green-500"
              />
              <span class="text-sm text-gray-700 dark:text-gray-300"
                ><font-awesome-icon
                  icon="bookmark"
                  class="text-green-500 mr-1"
                />
                {{ $t("card.types.story") }}</span
              >
            </label>
            <label class="flex items-center space-x-2 cursor-pointer">
              <input
                type="radio"
                v-model="modalState.addCard.card_type"
                value="task"
                class="text-blue-500 focus:ring-blue-500"
              />
              <span class="text-sm text-gray-700 dark:text-gray-300"
                ><font-awesome-icon
                  icon="check-square"
                  class="text-blue-500 mr-1"
                />
                {{ $t("card.types.task") }}</span
              >
            </label>
            <label class="flex items-center space-x-2 cursor-pointer">
              <input
                type="radio"
                v-model="modalState.addCard.card_type"
                value="bug"
                class="text-red-500 focus:ring-red-500"
              />
              <span class="text-sm text-gray-700 dark:text-gray-300"
                ><font-awesome-icon icon="bug" class="text-red-500 mr-1" />
                {{ $t("card.types.bug") }}</span
              >
            </label>
          </div>
        </div>

        <div>
          <label
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
          >
            {{ $t("card.description") }}
          </label>
          <textarea
            v-model="modalState.addCard.description"
            rows="3"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white focus:ring-indigo-500 focus:border-indigo-500"
            :placeholder="$t('card.description_placeholder')"
          ></textarea>
        </div>
        <div class="flex justify-end space-x-3 pt-2">
          <BaseButton
            variant="secondary"
            @click="modalState.addCard.isOpen = false"
          >
            {{ $t("common.cancel") }}
          </BaseButton>
          <BaseButton type="submit" :loading="modalState.addCard.loading">
            {{ $t("common.save") }}
          </BaseButton>
        </div>
      </form>
    </BaseModal>

    <!-- Card Detail Modal -->
    <CardDetailModal
      :isOpen="modalState.cardDetail.isOpen"
      :cardId="modalState.cardDetail.cardId"
      :board="board"
      :canEdit="canEdit"
      @close="modalState.cardDetail.isOpen = false"
      @refresh="emit('refresh')"
    />

    <!-- Delete Column Confirm Modal -->
    <BaseModal
      :isOpen="modalState.deleteColumn.isOpen"
      :title="$t('board.column.delete_confirm_title')"
      @close="modalState.deleteColumn.isOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t("board.column.delete_confirm_body") }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton
          variant="secondary"
          @click="modalState.deleteColumn.isOpen = false"
        >
          {{ $t("common.cancel") }}
        </BaseButton>
        <BaseButton
          variant="danger"
          :loading="modalState.deleteColumn.loading"
          @click="submitDeleteColumn"
        >
          {{ $t("common.confirm_delete") }}
        </BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup>
import { ref, watchEffect, reactive, computed } from "vue";
import draggable from "vuedraggable";
import api from "../api";
import { useAuthStore } from "../stores/auth";
import { useUIStore } from "../stores/ui";
import BaseModal from "./common/BaseModal.vue";
import BaseButton from "./common/BaseButton.vue";
import BoardColumn from "./BoardColumn.vue";
import CardDetailModal from "./CardDetailModal.vue";

const props = defineProps(["board"]);
const emit = defineEmits(["refresh"]);
const authStore = useAuthStore();
const uiStore = useUIStore();
const columns = ref([]);

const isOwner = computed(() => {
  return props.board?.created_by?.id === authStore.user?.id;
});

const canEdit = computed(() => {
  if (isOwner.value) return true;
  const role = props.board?.current_user_role;
  return role === "editor" || role === "owner";
});

// Modal States
const modalState = reactive({
  addColumn: { isOpen: false, title: "", loading: false },
  addCard: {
    isOpen: false,
    title: "",
    description: "",
    card_type: "task",
    columnId: null,
    loading: false,
  },
  deleteColumn: { isOpen: false, columnId: null, loading: false },
  cardDetail: {
    isOpen: false,
    cardId: null,
  },
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
      position: evt.newIndex + 1,
    });
  } catch (error) {
    console.error("Move column failed", error);
    emit("refresh");
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
      emit("refresh");
    } finally {
      uiStore.setLoading(false);
    }
  }
};

const openAddColumnModal = () => {
  modalState.addColumn.title = "";
  modalState.addColumn.isOpen = true;
};

const submitAddColumn = async () => {
  if (!modalState.addColumn.title) return;
  modalState.addColumn.loading = true;
  try {
    await api.post(`/boards/${props.board.id}/columns`, {
      title: modalState.addColumn.title,
    });
    modalState.addColumn.isOpen = false;
    emit("refresh");
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
    await api.delete(
      `/boards/${props.board.id}/columns/${modalState.deleteColumn.columnId}`
    );
    modalState.deleteColumn.isOpen = false;
    emit("refresh");
  } catch (error) {
    console.error("Delete column failed", error);
  } finally {
    modalState.deleteColumn.loading = false;
  }
};

const openAddCardModal = (column) => {
  modalState.addCard.columnId = column.id;
  modalState.addCard.title = "";
  modalState.addCard.description = "";
  modalState.addCard.card_type = "task";
  modalState.addCard.isOpen = true;
};

const submitAddCard = async () => {
  if (!modalState.addCard.title) return;
  modalState.addCard.loading = true;
  try {
    await api.post(`/cards`, {
      title: modalState.addCard.title,
      description: modalState.addCard.description,
      card_type: modalState.addCard.card_type,
      column_id: modalState.addCard.columnId,
      assignee_id: authStore.user.id,
    });
    modalState.addCard.isOpen = false;
    emit("refresh");
  } catch (error) {
    console.error("Create card failed", error);
  } finally {
    modalState.addCard.loading = false;
  }
};

const openCardDetail = (card) => {
  modalState.cardDetail.cardId = card.id;
  modalState.cardDetail.isOpen = true;
};
</script>
