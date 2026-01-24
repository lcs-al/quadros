<script setup>
import { useRouter } from 'vue-router';
import { ref } from 'vue';
import _imports_0 from '../assets/landing/capturar.png'
import _imports_1 from '../assets/landing/organizar.png'
import _imports_2 from '../assets/landing/engajar.png'

const router = useRouter(); 
const email = ref('');

const handleSignup = () => {
  if (email.value) {
    router.push({ name: 'Register', query: { email: email.value } });
  } else {
    router.push({ name: 'Register' });
  }
};

const scrollToFeatures = () => {
  const element = document.getElementById('section-1');
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' });
  }
};
</script>

<template>
  <div class="font-sans antialiased text-gray-100 bg-[#0F111A] min-h-screen overflow-x-hidden selection:bg-indigo-500/30">
    
    <!-- Custom Header for Landing Page -->
    <nav class="absolute top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-6 md:px-12 max-w-7xl mx-auto">
      <div class="flex items-center gap-3 cursor-pointer select-none">
        <div class="grid grid-cols-2 gap-0.5 w-6 h-6 rounded overflow-hidden">
          <div class="bg-indigo-600"></div>
          <div class="bg-green-500"></div>
          <div class="bg-orange-500"></div>
          <div class="bg-purple-600"></div>
        </div>
        <span class="text-xl font-bold tracking-tight text-white">{{ $t('navbar.brand') }}</span>
      </div>

      <router-link 
        to="/login"
        class="px-6 py-2 rounded-full text-sm font-semibold text-gray-900 bg-white hover:bg-gray-100 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
      >
        Entrar
      </router-link>
    </nav>

    <div class="snap-y snap-mandatory h-screen overflow-y-scroll scroll-smooth">
      
      <!-- Hero Section -->
      <section class="snap-start h-screen flex flex-col justify-center px-6 relative overflow-hidden">
        <!-- Ambient Glow Effects -->
        <div class="absolute top-1/4 left-0 w-[500px] h-[500px] bg-purple-900/20 rounded-full blur-[120px] -z-10 pointer-events-none"></div>
        <div class="absolute bottom-0 right-0 w-[600px] h-[600px] bg-indigo-900/10 rounded-full blur-[120px] -z-10 pointer-events-none"></div>

        <div class="max-w-7xl mx-auto w-full grid lg:grid-cols-2 gap-16 items-center z-10 mt-16">
          <div class="space-y-8 text-left">
            <h1 class="text-5xl md:text-6xl lg:text-7xl font-extrabold tracking-tight leading-[1.1]">
              Liberte sua mente.<br />
              <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
                Foque no que importa.
              </span>
            </h1>
            <p class="text-xl text-gray-400 max-w-lg leading-relaxed">
              Organize suas tarefas, projetos e ideias com um fluxo de trabalho claro e intuitivo.
            </p>

            <!-- Email Input and Call to Action -->
            <div class="pt-2 flex flex-col sm:flex-row gap-4 max-w-xl">
              <input
                v-model="email"
                type="email"
                placeholder="Seu melhor e-mail"
                class="flex-grow px-6 py-4 rounded-full border border-gray-700 bg-gray-800/50 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all shadow-inner text-lg"
                @keyup.enter="handleSignup"
              />
              <button 
                @click="handleSignup" 
                class="px-8 py-4 rounded-full bg-blue-600 text-white font-bold text-lg hover:bg-blue-700 transition-all shadow-lg hover:shadow-blue-600/30 whitespace-nowrap"
              >
                Criar conta grátis
              </button>
            </div>
            
          </div>
          
          <!-- Right Column / Image Board Mockup -->
          <div class="relative hidden lg:block">
             <!-- Abstract Board Representation -->
             <div class="relative rounded-xl overflow-hidden shadow-2xl border border-gray-800 bg-[#161822] transform rotate-1 hover:rotate-0 transition-all duration-700">
                <!-- Mock Header of App -->
                <div class="flex items-center gap-4 px-6 py-4 border-b border-gray-800">
                  <div class="flex gap-2">
                     <div class="w-3 h-3 rounded-full bg-red-500/50"></div>
                     <div class="w-3 h-3 rounded-full bg-yellow-500/50"></div>
                     <div class="w-3 h-3 rounded-full bg-green-500/50"></div>
                  </div>
                  <div class="h-2 w-32 bg-gray-800 rounded-full"></div>
                </div>
                <!-- Content -->
                <div class="p-6 grid grid-cols-3 gap-4 h-[400px]">
                   <!-- Col 1 -->
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">A Fazer</span>
                         <span class="text-xs text-gray-600">...</span>
                      </div>
                      <div class="bg-[#1C1E2B] p-3 rounded border border-gray-800/50 flex flex-col gap-2 relative overflow-hidden group">
                         <div class="absolute left-0 top-0 bottom-0 w-1 bg-green-500 rounded-l"></div>
                         <div class="h-2 w-3/4 bg-gray-700 rounded mb-1"></div>
                         <div class="flex justify-between items-center">
                            <div class="h-2 w-8 bg-gray-800 rounded"></div>
                            <div class="w-5 h-5 rounded-full bg-gray-700"></div>
                         </div>
                      </div>
                      <div class="bg-[#1C1E2B] p-3 rounded border border-gray-800/50 flex flex-col gap-2 relative overflow-hidden">
                         <div class="absolute left-0 top-0 bottom-0 w-1 bg-pink-500 rounded-l"></div>
                         <div class="h-2 w-1/2 bg-gray-700 rounded mb-1"></div>
                         <div class="flex justify-between items-center">
                            <div class="h-2 w-8 bg-gray-800 rounded"></div>
                            <div class="w-5 h-5 rounded-full bg-gray-700"></div>
                         </div>
                      </div>
                   </div>
                   <!-- Col 2 -->
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">Em Andamento</span>
                         <span class="text-xs text-gray-600">...</span>
                      </div>
                      <div class="bg-[#1C1E2B] p-3 rounded border border-gray-800/50 flex flex-col gap-2 relative overflow-hidden">
                         <div class="absolute left-0 top-0 bottom-0 w-1 bg-yellow-500 rounded-l"></div>
                         <div class="h-2 w-full bg-gray-700 rounded mb-1"></div>
                         <div class="h-20 w-full bg-gradient-to-br from-yellow-500/10 to-transparent rounded"></div> 
                         <div class="flex justify-between items-center mt-auto">
                            <div class="w-6 h-6 rounded-full bg-gray-600 border-2 border-[#1C1E2B]"></div>
                         </div>
                      </div>
                       <div class="bg-[#1C1E2B] p-3 rounded border border-gray-800/50 flex flex-col gap-2 relative overflow-hidden">
                         <div class="absolute left-0 top-0 bottom-0 w-1 bg-purple-500 rounded-l"></div>
                         <div class="h-2 w-2/3 bg-gray-700 rounded mb-1"></div>
                         <div class="flex justify-between items-center">
                            <div class="w-6 h-6 rounded-full bg-gray-600 border-2 border-[#1C1E2B]"></div>
                         </div>
                      </div>
                   </div>
                   <!-- Col 3 -->
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">Concluído</span>
                         <span class="text-xs text-gray-600">...</span>
                      </div>
                       <div class="bg-[#1C1E2B] p-3 rounded border border-gray-800/50 flex flex-col gap-2 relative overflow-hidden opacity-60">
                         <div class="absolute left-0 top-0 bottom-0 w-1 bg-blue-500 rounded-l"></div>
                         <div class="h-2 w-full bg-gray-700 rounded mb-1 line-through"></div>
                         <div class="flex justify-between items-center">
                            <div class="w-5 h-5 rounded-full bg-green-500/20 text-green-500 flex items-center justify-center text-[10px]">✓</div>
                         </div>
                      </div>
                   </div>
                </div>
             </div>
          </div>
        </div>

        <div class="absolute bottom-10 left-1/2 transform -translate-x-1/2 animate-bounce cursor-pointer opacity-50 hover:opacity-100 transition-opacity" @click="scrollToFeatures">
          <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"></path></svg>
        </div>
      </section>

      <!-- Section 2 -->
      <section id="section-1" class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-[#13151D]">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
          <div class="space-y-6">
            <div class="inline-block px-4 py-1 rounded-full bg-blue-900/30 text-blue-400 font-bold text-sm uppercase tracking-wide border border-blue-900/50">
              Passo 1: Capturar
            </div>
            <h2 class="text-4xl md:text-5xl font-bold text-white leading-tight">
              Tire tudo da <br /> sua cabeça.
            </h2>
            <p class="text-lg md:text-xl text-gray-400 leading-relaxed">
              O primeiro passo para a tranquilidade é capturar tudo o que chama sua atenção. Tarefas, ideias, lembretes – coloque tudo na sua Caixa de Entrada e esvazie sua mente para criar.
            </p>
          </div>
          <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group border border-gray-800">
             <img :src="_imports_0" alt="" class="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity">
          </div>
        </div>
      </section>

      <!-- Section 3 -->
      <section class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-[#0F111A]">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
          <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group border border-gray-800">
             <img :src="_imports_1" alt="Organizar" class="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity">
          </div>
          <div class="order-1 md:order-2 space-y-6">
            <div class="inline-block px-4 py-1 rounded-full bg-purple-900/30 text-purple-400 font-bold text-sm uppercase tracking-wide border border-purple-900/50">
              Passo 2: Organizar
            </div>
            <h2 class="text-4xl md:text-5xl font-bold text-white leading-tight">
              Cada coisa em <br /> seu lugar.
            </h2>
            <p class="text-lg md:text-xl text-gray-400 leading-relaxed">
              Defina o significado de cada item. É acionável? É uma referência? É lixo? Organize em listas claras como Próximas Ações, Projetos ou Aguardando, e nunca mais perca o controle.
            </p>
          </div>
        </div>
      </section>

      <!-- Section 4 -->
      <section class="snap-start h-screen flex flex-col justify-between p-6 md:p-12 md:px-24 bg-[#13151D]">
        <div class="flex-grow flex items-center w-full">
          <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
            <div class="space-y-6">
               <div class="inline-block px-4 py-1 rounded-full bg-green-900/30 text-green-400 font-bold text-sm uppercase tracking-wide border border-green-900/50">
                Passo 3: Engajar
              </div>
              <h2 class="text-4xl md:text-5xl font-bold text-white leading-tight">
                Execute com <br /> confiança.
              </h2>
              <p class="text-lg md:text-xl text-gray-400 leading-relaxed">
                Com seu sistema confiável e organizado, você pode escolher a tarefa certa para o momento certo, considerando seu contexto, tempo e energia disponível.
              </p>
            </div>
            <div class="relative h-[400px] md:h-[600px] w-full rounded-2xl overflow-hidden shadow-2xl group border border-gray-800">
               <img :src="_imports_2" alt="Engajar" class="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity">
            </div>
          </div>
        </div>

        <footer class="w-full py-8 border-t border-gray-800 mt-8">
          <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
            <div class="text-sm text-gray-500">
              Copyright © 2026 lcs-al
            </div>

						<div class="flex items-center gap-6 text-sm font-medium">
               <router-link to="/terms" class="text-gray-500 hover:text-indigo-400 transition-colors">
                Termos de Uso
              </router-link>
              <router-link to="/privacy" class="text-gray-500 hover:text-indigo-400 transition-colors">
                Política de Privacidade
              </router-link>
            </div>
            
            <div class="flex items-center gap-6">
              <a href="https://github.com/lcs-al" target="_blank" rel="noopener noreferrer" class="text-gray-500 hover:text-white transition-colors" title="GitHub">
                <font-awesome-icon :icon="['fab', 'github']" class="text-xl" />
              </a>
              <a href="https://www.linkedin.com/in/lcs-al/" target="_blank" rel="noopener noreferrer" class="text-gray-500 hover:text-blue-400 transition-colors" title="LinkedIn">
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
