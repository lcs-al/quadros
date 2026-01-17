<script setup>

const props = defineProps({
  isExpanded: {
    type: Boolean,
    required: true
  }
});

const emit = defineEmits(['toggle']);

const toggleSidebar = () => {
  emit('toggle');
};

const recentBoards = [
  { id: 1, name: 'Marketing Campaign', color: 'bg-blue-500' },
  { id: 2, name: 'Product Launch', color: 'bg-purple-500' },
  { id: 3, name: 'Q1 Goals', color: 'bg-green-500' },
];
</script>

<template>
  <aside 
    class="fixed left-0 top-16 h-[calc(100vh-4rem)] bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-800 transition-all duration-300 z-40 flex flex-col"
    :class="[isExpanded ? 'w-64' : 'w-20']"
  >
    <button 
      @click="toggleSidebar"
      class="absolute top-1/2 -right-3 transform -translate-y-1/2 w-6 h-6 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-full flex items-center justify-center cursor-pointer text-gray-400 hover:text-indigo-600 dark:hover:text-indigo-400 shadow-sm z-50 transition-colors"
      :title="isExpanded ? 'Collapse sidebar' : 'Expand sidebar'"
    >
      <font-awesome-icon :icon="isExpanded ? 'chevron-left' : 'chevron-right'" class="text-xs" />
    </button>
    <div class="flex flex-col flex-1 p-3 space-y-2 overflow-y-auto">

      <div class="space-y-1">
        <router-link
          to="/boards"
          class="flex items-center gap-3 px-3 py-2 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors group"
          :class="{ 'justify-center': !isExpanded }"
        >
          <font-awesome-icon icon="columns" class="w-5 h-5" />
          <span v-if="isExpanded" class="font-medium whitespace-nowrap group-hover:translate-x-1 transition-transform">Quadros</span>
        </router-link>

        <router-link
          to="/reports"
          class="flex items-center gap-3 px-3 py-2 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors group"
          :class="{ 'justify-center': !isExpanded }"
        >
           <font-awesome-icon icon="chart-pie" class="w-5 h-5" />
          <span v-if="isExpanded" class="font-medium whitespace-nowrap group-hover:translate-x-1 transition-transform">Relatórios</span>
        </router-link>
      </div>

      <div class="border-t border-gray-100 dark:border-gray-800 pt-4 mt-4">
        <div v-if="isExpanded" class="px-3 mb-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">
          Recentes
        </div>
        
        <div class="space-y-1">
          <router-link
            v-for="board in recentBoards"
            :key="board.id"
            :to="`/boards/${board.id}`"
            class="flex items-center gap-3 px-3 py-2 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            :class="{ 'justify-center': !isExpanded }"
          >
            <div class="w-2.5 h-2.5 rounded-full flex-shrink-0" :class="board.color"></div>
            <span v-if="isExpanded" class="truncate font-medium text-sm">{{ board.name }}</span>
          </router-link>
        </div>
      </div>
    </div>
  </aside>
</template>
