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

    <!-- Labels -->
    <div v-if="card.labels && card.labels.length" class="flex flex-wrap gap-1 mt-2">
      <span
        v-for="label in card.labels"
        :key="label"
        class="px-2 py-0.5 text-[10px] font-medium bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-full"
      >
        {{ label }}
      </span>
    </div>

    <!-- Metadata Row -->
    <div class="flex items-center gap-3 mt-3 text-xs text-gray-500 dark:text-gray-400">
      <!-- Priority -->
      <div v-if="card.priority !== undefined" class="flex items-center" :class="getPriorityColor(card.priority)">
        <font-awesome-icon :icon="getPriorityIcon(card.priority)" class="mr-1" />
        <span class="capitalize font-bold">{{ $t(`card.priorities.${card.priority || 'medium'}`) }}</span>
      </div>

       <!-- Due Date -->
      <div v-if="card.due_date" class="flex items-center" :class="getDueDateColor(card.due_date)">
        <font-awesome-icon icon="calendar-alt" class="mr-1" />
        <span>{{ formatDateShort(card.due_date) }}</span>
      </div>

      <!-- Story Points -->
      <div v-if="card.story_points" class="flex items-center bg-gray-100 dark:bg-gray-700 px-1.5 py-0.5 rounded">
        <span class="font-bold text-gray-700 dark:text-gray-300">{{ card.story_points }}</span>
      </div>
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

const getPriorityColor = (priority) => {
  switch (priority) {
    case 'critical': return 'text-red-600 font-bold';
    case 'high': return 'text-orange-500';
    case 'medium': return 'text-yellow-500';
    case 'low': return 'text-green-500';
    default: return 'text-gray-400';
  }
};

const getPriorityIcon = (priority) => {
  switch (priority) {
    case 'critical': return 'fire';
    case 'high': return 'arrow-up';
    case 'medium': return 'minus';
    case 'low': return 'arrow-down';
    default: return 'minus';
  }
};

const getDueDateColor = (date) => {
  if (!date) return '';
  const now = new Date();
  const due = new Date(date);
  if (due < now) return 'text-red-600 font-bold'; // Overdue
  const diffTime = Math.abs(due - now);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
  if (diffDays <= 2) return 'text-orange-500'; // Due soon
  return 'text-gray-500';
};

const formatDateShort = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString(undefined, { month: 'short', day: 'numeric' });
};
</script>
