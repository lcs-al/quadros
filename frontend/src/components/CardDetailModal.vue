<template>
  <div>
    <!-- Card Detail Modal -->
    <BaseModal
      :isOpen="isOpen"
      :title="modalState.data?.title || $t('card.title')"
      @close="close"
    >
      <template #headerActions v-if="canEdit && modalState.data">
        <div class="relative">
          <button
            @click.stop="toggleActionsMenu"
            class="p-1 px-2 rounded hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 transition-colors"
            :title="$t('card.actions')"
          >
            <font-awesome-icon icon="ellipsis-h" />
          </button>

          <div
            v-if="modalState.showActionsMenu"
            class="absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5 z-[70] py-1 focus:outline-none"
            v-click-outside="() => (modalState.showActionsMenu = false)"
          >
            <button
              @click="returnToBacklog"
              class="flex items-center w-full px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              <font-awesome-icon icon="archive" class="mr-3 text-gray-400" />
              {{ $t("card.return_to_backlog") }}
            </button>
            <button
              @click="confirmDelete"
              class="flex items-center w-full px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/10 transition-colors"
            >
              <font-awesome-icon icon="trash-alt" class="mr-3" />
              {{ $t("card.delete") }}
            </button>
          </div>
        </div>
      </template>
      <div v-if="modalState.loading" class="flex justify-center py-12">
        <font-awesome-icon
          icon="spinner"
          spin
          class="text-3xl text-indigo-600"
        />
      </div>
      <div
        v-else-if="modalState.data"
        class="grid grid-cols-1 lg:grid-cols-3 gap-8"
      >
        <!-- Main Column (Left) -->
        <div class="lg:col-span-2 space-y-8">
          <!-- Title & Description & Type Editing -->
          <div class="space-y-6">
            <!-- Type Selector in Edit Mode -->
            <div class="flex items-center space-x-4" v-if="canEdit">
              <select
                v-model="modalState.editData.card_type"
                @change="submitEditCard"
                class="text-xs font-bold uppercase tracking-wider border-none bg-transparent focus:ring-0 cursor-pointer pl-0"
                :class="getCardIconColor(modalState.editData.card_type)"
              >
                <option value="story">{{ $t("card.types.story") }}</option>
                <option value="task">{{ $t("card.types.task") }}</option>
                <option value="bug">{{ $t("card.types.bug") }}</option>
              </select>
            </div>
            <div v-else class="flex items-center space-x-2">
              <font-awesome-icon
                :icon="getCardIcon(modalState.data.card_type)"
                class="text-sm"
                :class="getCardIconColor(modalState.data.card_type)"
              />
              <span
                class="text-xs font-bold uppercase tracking-wider"
                :class="getCardIconColor(modalState.data.card_type)"
              >
                {{
                  $t(`card.types.${modalState.data.card_type || "task"}`)
                }}
              </span>
            </div>

            <div>
              <input
                v-model="modalState.editData.title"
                type="text"
                @blur="submitEditCard"
                :readonly="!canEdit"
                class="w-full text-2xl font-bold bg-transparent border-b-2 border-transparent hover:border-gray-200 dark:hover:border-gray-600 focus:border-indigo-500 dark:focus:border-indigo-400 focus:outline-none py-1 transition-all text-gray-900 dark:text-white"
                :class="{ 'cursor-default': !canEdit }"
                :placeholder="$t('card.title')"
              />
            </div>

            <div>
              <label
                class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-2"
              >
                {{ $t("card.description") }}
              </label>
              <textarea
                v-model="modalState.editData.description"
                rows="6"
                @blur="submitEditCard"
                :readonly="!canEdit"
                class="w-full px-4 py-3 bg-gray-50/50 dark:bg-gray-700/30 border border-transparent rounded-xl focus:border-indigo-500 dark:focus:border-indigo-400 focus:bg-white dark:focus:bg-gray-700 focus:outline-none transition-all text-gray-700 dark:text-gray-200 resize-none text-sm leading-relaxed"
                :class="{ 'cursor-default': !canEdit }"
                :placeholder="$t('card.description_placeholder')"
              ></textarea>
            </div>

            <!-- Labels -->
            <div class="space-y-2">
              <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                {{ $t("card.labels") }}
              </label>
              <div class="flex flex-wrap gap-2 mb-2">
                <span
                  v-for="label in modalState.editData.labels"
                  :key="label"
                  class="px-2 py-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-full text-xs flex items-center shadow-sm border border-gray-200 dark:border-gray-600"
                >
                  {{ label }}
                  <button
                    v-if="canEdit"
                    @click="removeLabel(label)"
                    class="ml-1 text-gray-400 hover:text-red-500 transition-colors"
                  >
                    <font-awesome-icon icon="times" />
                  </button>
                </span>
              </div>
              <div v-if="canEdit" class="flex items-center space-x-2">
                <input
                  v-model="modalState.newLabel"
                  @keydown.enter.prevent="addLabel"
                  type="text"
                  class="flex-1 px-3 py-1.5 text-sm border border-gray-200 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500"
                  :placeholder="$t('card.label_placeholder')"
                />
                <BaseButton
                  v-if="modalState.newLabel"
                  size="xs"
                  @click="addLabel"
                  variant="secondary"
                  class="flex-shrink-0"
                >
                  <font-awesome-icon icon="plus" />
                </BaseButton>
              </div>
            </div>
          </div>

          <!-- Comments Section -->
          <div
            class="space-y-6 pt-6 border-t border-gray-100 dark:border-gray-700"
          >
            <h4
              class="text-sm font-bold text-gray-900 dark:text-white flex items-center"
            >
              <font-awesome-icon icon="comment" class="mr-2 text-gray-400" />
              {{ $t("card.comments.title") }}
            </h4>

            <!-- Comment List -->
            <div
              class="space-y-4 max-h-[400px] overflow-y-auto pr-2 scrollbar-thin"
            >
              <div
                v-for="comment in modalState.data.comments"
                :key="comment.id"
                class="flex space-x-3 group"
              >
                <div class="flex-shrink-0">
                  <UserAvatar :user="comment.user" size="md" />
                </div>
                <div class="flex-1">
                  <div class="flex items-center space-x-2 mb-1">
                    <span
                      class="text-sm font-bold text-gray-900 dark:text-white"
                      >{{ comment.user?.name }}</span
                    >
                    <span class="text-[10px] text-gray-400 font-medium">{{
                      formatDate(comment.created_at)
                    }}</span>
                  </div>
                  <p
                    class="text-sm text-gray-700 dark:text-gray-300 bg-gray-50 dark:bg-gray-800/50 p-3 rounded-lg border border-transparent hover:border-gray-200 dark:hover:border-gray-700 transition-colors"
                  >
                    {{ comment.content }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Add Comment -->
            <div class="flex space-x-3 mt-6">
              <div class="flex-shrink-0">
                <UserAvatar
                  v-if="authStore.user"
                  :user="authStore.user"
                  size="md"
                />
              </div>
              <div class="flex-1 space-y-3">
                <textarea
                  v-model="modalState.newComment"
                  @keydown.enter.ctrl.prevent="submitAddComment"
                  rows="3"
                  class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 text-sm transition-shadow"
                  :placeholder="$t('card.comments.placeholder')"
                ></textarea>
                <div
                  class="flex justify-between items-center text-[10px] text-gray-400"
                >
                  <span>{{
                    $t("common.ctrl_enter_to_post") || "Ctrl + Enter to post"
                  }}</span>
                  <BaseButton
                    size="sm"
                    :loading="modalState.commentLoading"
                    @click="submitAddComment"
                    :disabled="!modalState.newComment.trim()"
                    class="rounded-full px-6"
                  >
                    {{ $t("card.comments.post") }}
                  </BaseButton>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar Column (Right) -->
        <div class="space-y-6">
          <div
            class="bg-gray-50/50 dark:bg-gray-800/30 rounded-2xl p-5 border border-gray-100 dark:border-gray-700 space-y-6"
          >
            <div>
              <span class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">{{ $t("card.priority") }}</span>
              <div class="relative">
                <select
                    v-model="modalState.editData.priority"
                    @change="submitEditCard"
                    :disabled="!canEdit"
                    class="block w-full px-3 py-2 text-sm border-2 border-transparent focus:border-indigo-500 rounded-xl dark:bg-gray-700 dark:text-gray-200 appearance-none transition-all hover:bg-gray-100 dark:hover:bg-gray-600 cursor-pointer font-medium capitalize"
                >
                    <option value="low">{{ $t("card.priorities.low") }}</option>
                    <option value="medium">{{ $t("card.priorities.medium") }}</option>
                    <option value="high">{{ $t("card.priorities.high") }}</option>
                    <option value="critical">{{ $t("card.priorities.critical") }}</option>
                </select>
                <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none text-gray-400">
                    <font-awesome-icon icon="chevron-down" class="text-[10px]" />
                </div>
              </div>
            </div>

            <div>
            <span class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">{{ $t("card.story_points") }}</span>
            <input
                v-model="modalState.editData.story_points"
                @change="submitEditCard"
                type="number"
                min="0"
                :readonly="!canEdit"
                class="block w-full px-3 py-2 text-sm border-2 border-transparent focus:border-indigo-500 rounded-xl dark:bg-gray-700 dark:text-gray-200 transition-all hover:bg-gray-100 dark:hover:bg-gray-600 focus:bg-white dark:focus:bg-gray-700"
                :class="{ 'cursor-default': !canEdit }"
                placeholder="-"
            />
            </div>

            <div>
                <span class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">{{ $t("card.due_date") }}</span>
                <input
                v-model="modalState.editData.due_date"
                @change="submitEditCard"
                type="date"
                :readonly="!canEdit"
                class="block w-full px-3 py-2 text-sm border-2 border-transparent focus:border-indigo-500 rounded-xl dark:bg-gray-700 dark:text-gray-200 transition-all hover:bg-gray-100 dark:hover:bg-gray-600 focus:bg-white dark:focus:bg-gray-700"
                :class="{ 'cursor-default': !canEdit }"
                />
            </div>
          
            <div>
              <span
                class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2"
                >{{ $t("card.metadata.creator") }}</span
              >
              <div class="flex items-center">
                <UserAvatar
                  v-if="modalState.data.creator"
                  :user="modalState.data.creator"
                  size="sm"
                  class="mr-3"
                />
                <span
                  class="text-sm font-medium text-gray-700 dark:text-gray-200"
                >
                  {{
                    modalState.data.creator?.name || $t("card.metadata.unknown")
                  }}
                </span>
              </div>
            </div>

            <div>
              <span
                class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2"
                >{{ $t("card.metadata.assignee") }}</span
              >
              <div class="relative group">
                <select
                  :value="modalState.data.assignee?.id"
                  @change="submitUpdateAssignee($event.target.value)"
                  class="block w-full pl-9 pr-10 py-2 text-sm border-2 border-transparent focus:border-indigo-500 rounded-xl dark:bg-gray-700 dark:text-gray-200 appearance-none transition-all hover:bg-gray-100 dark:hover:bg-gray-600 cursor-pointer font-medium"
                  :disabled="modalState.loadingUsers || !canEdit"
                >
                  <option :value="null">
                    {{ $t("card.metadata.unassigned") }}
                  </option>
                  <option
                    v-for="user in modalState.users"
                    :key="user.id"
                    :value="user.id"
                  >
                    {{ user.name }}
                  </option>
                </select>
                <div
                  class="absolute inset-y-0 left-0 pl-2.5 flex items-center pointer-events-none"
                >
                  <UserAvatar
                    v-if="modalState.data.assignee"
                    :user="modalState.data.assignee"
                    size="xs"
                  />
                  <font-awesome-icon
                    v-else
                    icon="user-circle"
                    class="text-gray-400 h-4 w-4"
                  />
                </div>
                <div
                  class="absolute inset-y-0 right-3 flex items-center pointer-events-none text-gray-400 group-hover:text-indigo-500 transition-colors"
                >
                  <font-awesome-icon icon="chevron-down" class="text-[10px]" />
                </div>
                <div
                  v-if="modalState.loadingUsers"
                  class="absolute inset-y-0 right-8 flex items-center pointer-events-none"
                >
                  <font-awesome-icon
                    icon="spinner"
                    spin
                    class="text-indigo-500 text-xs"
                  />
                </div>
              </div>
            </div>

            <div>
              <span
                class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2"
                >{{ $t("card.metadata.created_at") }}</span
              >
              <span
                class="text-sm font-medium text-gray-600 dark:text-gray-400 flex items-center"
              >
                <font-awesome-icon icon="clock" class="mr-2 text-xs" />
                {{ formatDate(modalState.data.created_at) }}
              </span>
            </div>
          </div>

        </div>
      </div>
    </BaseModal>

    <!-- Delete Card Confirm Modal -->
    <BaseModal
      :isOpen="modalState.deleteOpen"
      :title="$t('common.confirm_delete')"
      @close="modalState.deleteOpen = false"
    >
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ $t("card.delete_confirm") }}
      </p>
      <div class="flex justify-end space-x-3">
        <BaseButton
          variant="secondary"
          @click="modalState.deleteOpen = false"
          >{{ $t("common.cancel") }}</BaseButton
        >
        <BaseButton
          variant="danger"
          :loading="modalState.deleteLoading"
          @click="submitDelete"
          >{{ $t("common.delete") }}</BaseButton
        >
      </div>
    </BaseModal>
  </div>
</template>

<script setup>
import { reactive, watch } from "vue";
import api from "../api";
import { useAuthStore } from "../stores/auth";
import { useUIStore } from "../stores/ui";
import { useI18n } from "vue-i18n";
import BaseModal from "./common/BaseModal.vue";
import BaseButton from "./common/BaseButton.vue";
import UserAvatar from "./common/UserAvatar.vue";

const props = defineProps({
  isOpen: Boolean,
  cardId: Number,
  board: Object,
  canEdit: Boolean,
});

const emit = defineEmits(["close", "refresh"]);

const authStore = useAuthStore();
const uiStore = useUIStore();
const { t } = useI18n();

const modalState = reactive({
  loading: false,
  data: null,
  editData: { title: "", description: "", card_type: "task", priority: "medium", story_points: null, due_date: null, labels: [] },
  newLabel: "",
  newComment: "",
  commentLoading: false,
  users: [],
  loadingUsers: false,
  showActionsMenu: false,
  deleteOpen: false,
  deleteLoading: false,
});

const fetchUsers = async () => {
  if (modalState.users.length > 0) return;
  modalState.loadingUsers = true;
  try {
    const response = await api.get("/users");
    modalState.users = response.data;
  } catch (error) {
    console.error("Fetch users failed", error);
  } finally {
    modalState.loadingUsers = false;
  }
};

const fetchCardDetails = async (id) => {
  modalState.loading = true;
  fetchUsers();
  try {
    const response = await api.get(`/cards/${id}`);
    modalState.data = response.data;
    modalState.editData.title = response.data.title;
    modalState.editData.description = response.data.description || "";
    modalState.editData.card_type = response.data.card_type || "task";
    modalState.editData.priority = response.data.priority || "medium";
    modalState.editData.story_points = response.data.story_points;
    modalState.editData.due_date = response.data.due_date ? response.data.due_date.split('T')[0] : null;
    modalState.editData.labels = response.data.labels ? [...response.data.labels] : [];
  } catch (error) {
    console.error("Fetch card details failed", error);
    emit("close");
  } finally {
    modalState.loading = false;
  }
};

watch(
  () => props.isOpen,
  (newVal) => {
    if (newVal && props.cardId) {
      fetchCardDetails(props.cardId);
    } else if (!newVal) {
      modalState.data = null;
      modalState.newComment = "";
      modalState.showActionsMenu = false;
    }
  }
);

const submitUpdateAssignee = async (userId) => {
  if (!modalState.data) return;
  try {
    const response = await api.patch(`/cards/${modalState.data.id}`, {
      assignee_id: userId,
    });
    modalState.data = { ...modalState.data, ...response.data };
    emit("refresh");
  } catch (error) {
    console.error("Update assignee failed", error);
  }
};

const submitEditCard = async () => {
  if (!modalState.data || !modalState.editData.title) return;
  if (
    modalState.data.title === modalState.editData.title &&
    modalState.data.description === modalState.editData.description &&
    modalState.data.card_type === modalState.editData.card_type
  )
    return;

  try {
    const response = await api.patch(`/cards/${modalState.data.id}`, {
      title: modalState.editData.title,
      description: modalState.editData.description,
      card_type: modalState.editData.card_type,
      priority: modalState.editData.priority,
      story_points: modalState.editData.story_points,
      due_date: modalState.editData.due_date,
      labels: modalState.editData.labels,
    });
    modalState.data = { ...modalState.data, ...response.data };
    emit("refresh");
  } catch (error) {
    console.error("Update card failed", error);
  }
};

const addLabel = () => {
  const label = modalState.newLabel.trim();
  if (label && !modalState.editData.labels.includes(label)) {
    modalState.editData.labels.push(label);
    modalState.newLabel = "";
    submitEditCard();
  }
};

const removeLabel = (label) => {
  modalState.editData.labels = modalState.editData.labels.filter(l => l !== label);
  submitEditCard();
};

const submitAddComment = async () => {
  if (!modalState.data || !modalState.newComment.trim()) return;
  modalState.commentLoading = true;
  try {
    const response = await api.post(`/cards/${modalState.data.id}/comments`, {
      content: modalState.newComment,
    });
    const commentWithUser = { ...response.data, user: authStore.user };
    modalState.data.comments.push(commentWithUser);
    modalState.newComment = "";
  } catch (error) {
    console.error("Add comment failed", error);
  } finally {
    modalState.commentLoading = false;
  }
};

const returnToBacklog = async () => {
  const backlogId = props.board?.backlog?.id;
  if (!modalState.data || !backlogId) return;
  try {
    await api.patch(`/cards/${modalState.data.id}/move`, {
      backlog_id: backlogId,
      position: 1,
    });
    emit("close");
    emit("refresh");
    uiStore.addNotification({
      type: "success",
      message:
        t("card.return_to_backlog_success") || "Card returned to backlog",
    });
  } catch (error) {
    console.error("Return to backlog failed", error);
  }
};

const confirmDelete = () => {
  modalState.showActionsMenu = false;
  modalState.deleteOpen = true;
};

const submitDelete = async () => {
  const cardId = modalState.data.id;
  modalState.deleteLoading = true;
  try {
    await api.delete(`/cards/${cardId}`);
    modalState.deleteOpen = false;
    emit("close");
    emit("refresh");
    uiStore.addNotification({
      type: "info",
      message: t("card.delete_success") || "Card deleted",
      action: {
        label: t("common.undo"),
        callback: () => submitRestoreCard(cardId),
      },
    });
  } catch (error) {
    console.error("Delete card failed", error);
  } finally {
    modalState.deleteLoading = false;
  }
};

const submitRestoreCard = async (cardId) => {
  try {
    await api.post(`/cards/${cardId}/restore`);
    emit("refresh");
    uiStore.addNotification({
      type: "success",
      message: t("card.restore_success"),
    });
  } catch (error) {
    console.error("Restore card failed", error);
  }
};

const toggleActionsMenu = () => {
  modalState.showActionsMenu = !modalState.showActionsMenu;
};

const formatDate = (dateString) => {
  if (!dateString) return "";
  return new Date(dateString).toLocaleString();
};

const getCardIcon = (type) => {
  switch (type) {
    case "story":
      return "bookmark";
    case "bug":
      return "bug";
    default:
      return "check-square";
  }
};

const getCardIconColor = (type) => {
  switch (type) {
    case "story":
      return "text-green-600 dark:text-green-400";
    case "bug":
      return "text-red-600 dark:text-red-400";
    default:
      return "text-blue-600 dark:text-blue-400";
  }
};

const close = () => emit("close");
</script>
