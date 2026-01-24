<template>
  <Teleport to="body">
    <Transition name="fade">
      <div 
        v-if="isOpen" 
        class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm"
        @click.self="closeOnBackdrop"
      >
        <Transition name="scale" appear>
          <div 
            v-if="isOpen"
            class="bg-white dark:bg-[#1A1D26] rounded-lg shadow-xl w-full max-w-4xl overflow-hidden"
          >
            <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
              <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ title }}</h3>
              <div class="flex items-center space-x-2">
                <slot name="headerActions"></slot>
                <button 
                  @click="close"
                  class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-colors"
                >
                  <font-awesome-icon icon="times" class="h-5 w-5" />
                </button>
              </div>
            </div>

            <!-- Body -->
            <div class="px-6 py-6">
              <slot></slot>
            </div>

            <!-- Footer -->
            <div v-if="$slots.footer" class="px-6 py-4 bg-gray-50 dark:bg-[#1A1D26]/50 border-t border-gray-100 dark:border-gray-700 flex justify-end space-x-3">
              <slot name="footer"></slot>
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
const props = defineProps({
  isOpen: Boolean,
  title: String,
  closeOnBackdrop: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['close']);

const close = () => {
  emit('close');
};

const closeOnBackdrop = () => {
  if (props.closeOnBackdrop) {
    close();
  }
};
</script>
