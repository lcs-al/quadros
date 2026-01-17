import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useBoardStore = defineStore('boards', () => {
  const storedRecent = localStorage.getItem('recentBoards');
  const recentBoards = ref(storedRecent ? JSON.parse(storedRecent) : []);

    const colors = [
        'bg-red-500', 'bg-orange-500', 'bg-amber-500', 'bg-yellow-500',
        'bg-lime-500', 'bg-green-500', 'bg-emerald-500', 'bg-teal-500',
        'bg-cyan-500', 'bg-sky-500', 'bg-blue-500', 'bg-indigo-500',
        'bg-violet-500', 'bg-purple-500', 'bg-fuchsia-500', 'bg-pink-500',
        'bg-rose-500'
    ];

    const getRandomColor = () => colors[Math.floor(Math.random() * colors.length)];

  const addToRecent = (board) => {
    const existingIndex = recentBoards.value.findIndex(b => b.id === board.id);
    if (existingIndex !== -1) {
      recentBoards.value.splice(existingIndex, 1);
    }

    recentBoards.value.unshift({
      id: board.id,
      name: board.title,
        color: board.color || getRandomColor()
    });

    if (recentBoards.value.length > 3) {
      recentBoards.value = recentBoards.value.slice(0, 3);
    }

    localStorage.setItem('recentBoards', JSON.stringify(recentBoards.value));
  };

  return {
    recentBoards,
    addToRecent
  };
});
