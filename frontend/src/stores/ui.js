import { defineStore } from 'pinia';

export const useUIStore = defineStore('ui', {
  state: () => ({
    isLoading: false,
    notifications: [],
    modals: []
  }),
  actions: {
    setLoading(status) {
      this.isLoading = status;
    },
    addNotification(notification) {
      const id = Date.now();
      this.notifications.push({ id, ...notification });
      setTimeout(() => {
        this.removeNotification(id);
      }, 5000);
    },
    removeNotification(id) {
      this.notifications = this.notifications.filter(n => n.id !== id);
    }
  }
});
