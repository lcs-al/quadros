<template>
  <div
    class="flex-shrink-0 w-80 bg-gray-200 dark:bg-gray-800 rounded-md shadow-md flex flex-col max-h-full"
  >
    <!-- Column Header -->
    <div
      class="p-3 flex justify-between items-center bg-gray-300 dark:bg-gray-700 rounded-t-md column-handle cursor-move"
    >
      <h3 class="font-bold text-gray-700 dark:text-gray-200">
        {{ column.title }}
      </h3>
      <div class="flex space-x-1">
        <!-- Add Card Button -->
        <button
          v-if="canEdit"
          @click="$emit('add-card', column)"
          class="cursor-pointer text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        >
          <font-awesome-icon icon="plus" class="h-4 w-4" />
        </button>
        <!-- Delete Column (Owner or Editor) -->
        <button
          v-if="canEdit"
          @click="$emit('delete-column', column.id)"
          class="cursor-pointer text-red-500 hover:text-red-700"
        >
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
        @change="(evt) => $emit('card-change', evt, column.id)"
        :disabled="!canEdit"
      >
        <template #item="{ element: card }">
          <BoardCard :card="card" @click="$emit('card-click', card)" />
        </template>
      </draggable>
    </div>
  </div>
</template>

<script setup>
import draggable from "vuedraggable";
import BoardCard from "./BoardCard.vue";

defineProps({
  column: {
    type: Object,
    required: true,
  },
  canEdit: {
    type: Boolean,
    default: false,
  },
});

defineEmits(["add-card", "delete-column", "card-click", "card-change"]);
</script>
