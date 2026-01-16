<template>
  <div 
    :class="[
      sizeClasses, 
      'rounded-full flex items-center justify-center text-white font-bold border-2 border-white dark:border-gray-800 shadow-sm overflow-hidden flex-shrink-0'
    ]"
    :title="user?.name"
  >
    <img 
      v-if="user?.avatar_url" 
      :src="user.avatar_url" 
      class="h-full w-full object-cover" 
      @error="handleImageError"
    />
    <span v-else :class="textClasses">{{ initials }}</span>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  user: {
    type: Object,
    required: false,
    default: () => ({})
  },
  size: {
    type: String,
    default: 'md' // xs, sm, md, lg, xl
  }
});

const sizeClasses = computed(() => {
  switch (props.size) {
    case 'xs': return 'h-5 w-5';
    case 'sm': return 'h-6 w-6';
    case 'md': return 'h-8 w-8';
    case 'lg': return 'h-10 w-10';
    case 'xl': return 'h-12 w-12';
    case '2xl': return 'h-24 w-24';
    default: return 'h-8 w-8';
  }
});

const textClasses = computed(() => {
  switch (props.size) {
    case 'xs': return 'text-[8px]';
    case 'sm': return 'text-[10px]';
    case 'md': return 'text-xs';
    case 'lg': return 'text-sm';
    case 'xl': return 'text-base';
    case '2xl': return 'text-3xl';
    default: return 'text-xs';
  }
});

const initials = computed(() => {
  if (!props.user?.name) return '?';
  const names = props.user.name.split(' ');
  if (names.length >= 2) {
    return (names[0][0] + names[names.length - 1][0]).toUpperCase();
  }
  return names[0][0].toUpperCase();
});

const handleImageError = (e) => {
  // If image fails to load, we can hide it to show initials
  e.target.style.display = 'none';
};
</script>
