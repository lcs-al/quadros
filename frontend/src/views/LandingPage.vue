<script setup>
import { useRouter } from 'vue-router';
import Navbar from '../components/common/Navbar.vue';
import _imports_0 from '../assets/landing/capturar.png'
import _imports_1 from '../assets/landing/organizar.png'
import _imports_2 from '../assets/landing/engajar.png'

const router = useRouter(); 

const scrollToFeatures = () => {
  const element = document.getElementById('section-1');
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' });
  }
};
</script>

<template>
  <div class="font-sans antialiased text-gray-900 bg-white dark:bg-gray-900 dark:text-gray-100 overflow-x-hidden">
    <Navbar />

    <div class="snap-y snap-mandatory h-screen overflow-y-scroll scroll-smooth">
      
      <section class="snap-start h-screen flex flex-col items-center justify-center px-6 relative overflow-hidden">
        <div class="absolute top-0 left-1/4 w-96 h-96 bg-purple-200/50 dark:bg-purple-900/20 rounded-full blur-[100px] -z-10 animate-pulse"></div>
        <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-blue-200/50 dark:bg-blue-900/20 rounded-full blur-[100px] -z-10 animate-pulse" style="animation-delay: 1s"></div>

        <div class="max-w-4xl text-center z-10 space-y-8">
          <h1 class="text-5xl md:text-7xl font-extrabold tracking-tight leading-tight">
            Liberte sua mente.<br />
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
              Foque no que importa.
            </span>
          </h1>
          <p class="text-xl md:text-2xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto leading-relaxed">
            Uma plataforma intuitiva baseada no método GTD para organizar suas ideias, projetos e tarefas em um fluxo de trabalho natural.
          </p>
          <div class="flex items-center justify-center gap-4 pt-4">
            <button @click="scrollToFeatures" class="cursor-pointer px-8 py-4 rounded-full bg-indigo-600 text-white font-bold text-lg hover:bg-indigo-700 transition-all shadow-xl hover:shadow-indigo-500/30">
              Conheça o Método
            </button>
            <router-link to="/login" class="px-8 py-4 rounded-full bg-gray-100 text-gray-900 dark:bg-gray-800 dark:text-white font-bold text-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-all">
              Começar Agora
            </router-link>
          </div>
        </div>

        <div class="absolute bottom-10 animate-bounce cursor-pointer" @click="scrollToFeatures">
          <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"></path></svg>
        </div>
      </section>

      <section id="section-1" class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-gray-50 dark:bg-gray-800/50">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
          <div class="space-y-6">
            <div class="inline-block px-4 py-1 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 font-bold text-sm uppercase tracking-wide">
              Passo 1: Capturar
            </div>
            <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white leading-tight">
              Tire tudo da <br /> sua cabeça.
            </h2>
            <p class="text-lg md:text-xl text-gray-600 dark:text-gray-300 leading-relaxed">
              O primeiro passo para a tranquilidade é capturar tudo o que chama sua atenção. Tarefas, ideias, lembretes – coloque tudo na sua Caixa de Entrada e esvazie sua mente para criar.
            </p>
          </div>
          <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group">
             <img :src="_imports_0" alt="" class="w-full h-full object-cover">
          </div>
        </div>
      </section>

      <section class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-white dark:bg-gray-900">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
          <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group">
             <img :src="_imports_1" alt="Organizar" class="w-full h-full object-cover">
          </div>
          <div class="order-1 md:order-2 space-y-6">
            <div class="inline-block px-4 py-1 rounded-full bg-purple-100 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400 font-bold text-sm uppercase tracking-wide">
              Passo 2: Organizar
            </div>
            <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white leading-tight">
              Cada coisa em <br /> seu lugar.
            </h2>
            <p class="text-lg md:text-xl text-gray-600 dark:text-gray-300 leading-relaxed">
              Defina o significado de cada item. É acionável? É uma referência? É lixo? Organize em listas claras como Próximas Ações, Projetos ou Aguardando, e nunca mais perca o controle.
            </p>
          </div>
        </div>
      </section>

      <section class="snap-start h-screen flex flex-col justify-between p-6 md:p-12 md:px-24 bg-gray-50 dark:bg-gray-800/50">
        <div class="flex-grow flex items-center w-full">
          <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
            <div class="space-y-6">
               <div class="inline-block px-4 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 font-bold text-sm uppercase tracking-wide">
                Passo 3: Engajar
              </div>
              <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white leading-tight">
                Execute com <br /> confiança.
              </h2>
              <p class="text-lg md:text-xl text-gray-600 dark:text-gray-300 leading-relaxed">
                Com seu sistema confiável e organizado, você pode escolher a tarefa certa para o momento certo, considerando seu contexto, tempo e energia disponível.
              </p>
            </div>
            <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group">
               <img :src="_imports_2" alt="Engajar" class="w-full h-full object-cover">
            </div>
          </div>
        </div>

        <footer class="w-full py-4 border-t border-gray-200 dark:border-gray-700/50 mt-8">
          <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
            <div class="text-sm text-gray-500 dark:text-gray-400">
              Copyright © 2026 lcs-al
            </div>

						<div class="flex items-center gap-6 text-sm font-medium">
               <router-link to="/terms" class="text-gray-500 hover:text-indigo-600 dark:text-gray-400 dark:hover:text-indigo-400 transition-colors">
                Termos de Uso
              </router-link>
              <router-link to="/privacy" class="text-gray-500 hover:text-indigo-600 dark:text-gray-400 dark:hover:text-indigo-400 transition-colors">
                Política de Privacidade
              </router-link>
            </div>
            
            <div class="flex items-center gap-6">
              <a href="https://github.com/lcs-al" target="_blank" rel="noopener noreferrer" class="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors" title="GitHub">
                <font-awesome-icon :icon="['fab', 'github']" class="text-xl" />
              </a>
              <a href="https://www.linkedin.com/in/lcs-al/" target="_blank" rel="noopener noreferrer" class="text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors" title="LinkedIn">
                <font-awesome-icon :icon="['fab', 'linkedin']" class="text-xl" />
              </a>
            </div>
          </div>
        </footer>
      </section>

    </div>
  </div>
</template>

<style scoped>
::-webkit-scrollbar {
  width: 0px;
  background: transparent;
}
</style>
