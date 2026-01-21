<template>
  <div
    @click="$emit('click', card)"
    class="bg-white dark:bg-gray-600 p-3 rounded shadow cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-500 text-left border-l-4 group transition-all"
    :class="getCardBorderColor(card.card_type)"
  >
    <div class="flex items-center mb-1">
      <font-awesome-icon
        :icon="getCardIcon(card.card_type)"
        class="text-xs mr-2 opacity-70"
        :class="getCardIconColor(card.card_type)"
      />
      <span
        class="text-xs uppercase font-bold tracking-wider opacity-60"
        :class="getCardIconColor(card.card_type)"
      >
        {{ $t(`card.types.${card.card_type || 'task'}`) }}
      </span>
    </div>
    {{ card.title }}

    <div
      class="text-sm text-gray-500 dark:text-gray-300 mt-1 line-clamp-2"
      v-if="card.description"
    >
      {{ card.description }}
    </div>

    <!-- Assignee Avatar -->
    <div class="mt-2 flex items-center justify-between">
      <div v-if="card.assignee" class="flex items-center">
        <UserAvatar :user="card.assignee" size="sm" />
        <span class="text-[10px] text-gray-400 ml-2">
          {{ card.assignee.name }}
        </span>
      </div>
      <div class="flex items-center space-x-2 text-gray-400">
        <font-awesome-icon
          v-if="card.description"
          icon="align-left"
          class="text-[10px]"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import UserAvatar from "./common/UserAvatar.vue";

defineProps({
  card: {
    type: Object,
    required: true,
  },
});

defineEmits(["click"]);

const getCardBorderColor = (type) => {
  switch (type) {
    case "story":
      return "border-green-400 dark:border-green-500";
    case "bug":
      return "border-red-400 dark:border-red-500";
    default:
      return "border-blue-400 dark:border-blue-500";
  }
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
</script>
