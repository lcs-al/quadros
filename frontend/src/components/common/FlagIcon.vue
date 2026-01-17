<template>
  <div 
    class="relative inline-block w-6 h-4 rounded-sm overflow-hidden shadow-sm border border-gray-100 dark:border-gray-700"
    :title="title"
    :aria-label="title"
  >
    <img 
      v-if="country === 'BR'" 
      src="../../assets/flags/br.png" 
      :alt="title || 'Brasil'"
      class="w-full h-full object-cover"
    />
    <img 
      v-else-if="country === 'US'" 
      src="../../assets/flags/usa.png" 
      :alt="title || 'USA'"
      class="w-full h-full object-cover"
    />
  </div>
</template>

<script setup>
defineProps({
  country: {
    type: String,
    required: true,
    validator: (value) => ['BR', 'US'].includes(value)
  },
  title: String
});
</script>
