<template>
  <button
    :disabled="disabled || loading"
    :class="[
      'inline-flex items-center justify-center px-4 py-2 rounded-md font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed',
      variantClasses,
      sizeClasses
    ]"
    @click="$emit('click', $event)"
  >
    <div v-if="loading" class="mr-2">
      <span class="loader-spinner !w-4 !h-4"></span>
    </div>
    <slot></slot>
  </button>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  variant: {
    type: String,
    default: 'primary' // 'primary', 'secondary', 'danger', 'ghost'
  },
  size: {
    type: String,
    default: 'md' // 'sm', 'md', 'lg'
  },
  loading: Boolean,
  disabled: Boolean
});

defineEmits(['click']);

const variantClasses = computed(() => {
  switch (props.variant) {
    case 'primary':
      return 'bg-indigo-600 text-white hover:bg-indigo-700 focus:ring-indigo-500';
    case 'secondary':
      return 'bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 focus:ring-indigo-500';
    case 'danger':
      return 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500';
    case 'ghost':
      return 'bg-transparent text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:ring-gray-400';
    default:
      return 'bg-indigo-600 text-white hover:bg-indigo-700';
  }
});

const sizeClasses = computed(() => {
  switch (props.size) {
    case 'sm': return 'text-xs px-2.5 py-1.5';
    case 'md': return 'text-sm px-4 py-2';
    case 'lg': return 'text-base px-6 py-3';
    default: return 'text-sm px-4 py-2';
  }
});
</script>
