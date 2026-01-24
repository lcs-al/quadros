<script setup>
import { useRouter } from 'vue-router';
import { ref } from 'vue';

import Navbar from '../components/common/Navbar.vue';

import _imports_0 from '../assets/landing/capturar.png'
import _imports_1 from '../assets/landing/organizar.png'

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
    <Navbar />

    <div class="snap-y snap-mandatory h-screen overflow-y-scroll scroll-smooth">
      <section class="snap-start h-screen flex flex-col justify-center px-6 relative overflow-hidden">
        <div class="absolute top-1/4 left-0 w-[500px] h-[500px] bg-purple-900/20 rounded-full blur-[120px] -z-10 pointer-events-none"></div>
        <div class="absolute bottom-0 right-0 w-[600px] h-[600px] bg-indigo-900/10 rounded-full blur-[120px] -z-10 pointer-events-none"></div>

        <div class="max-w-7xl mx-auto w-full grid lg:grid-cols-2 gap-16 items-center z-10 mt-16">
          <div class="space-y-8 text-left">
            <h1 class="text-5xl md:text-4xl lg:text-5xl font-extrabold tracking-tight leading-[1.1]">
              {{ $t('landing.hero.title_start') }}<br />
              <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500">
                {{ $t('landing.hero.title_end') }}
              </span>
            </h1>
            <p class="text-xl text-gray-400 max-w-lg leading-relaxed">
              {{ $t('landing.hero.description') }}
            </p>

            <div class="pt-2 flex flex-col sm:flex-row gap-4 max-w-xl">
              <input
                v-model="email"
                type="email"
                :placeholder="$t('landing.hero.email_placeholder')"
                class="flex-grow px-6 py-4 rounded-full border border-gray-700 bg-gray-800/50 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all shadow-inner text-lg"
                @keyup.enter="handleSignup"
              />
              <button 
                @click="handleSignup" 
                class="px-8 py-4 rounded-full bg-blue-600 text-white font-bold text-lg hover:bg-blue-700 transition-all shadow-lg hover:shadow-blue-600/30 whitespace-nowrap"
              >
                {{ $t('landing.hero.cta') }}
              </button>
            </div>
          </div>
          
          <div class="relative hidden lg:block">
             <div class="absolute -inset-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 rounded-xl blur-lg opacity-30"></div>
             <div class="relative rounded-xl overflow-hidden shadow-2xl border border-gray-800 bg-[#161822] transform rotate-1 hover:rotate-0 transition-all duration-700">
                <div class="flex items-center gap-4 px-6 py-4 border-b border-gray-800">
                  <div class="flex gap-2">
                     <div class="w-3 h-3 rounded-full bg-red-500/50"></div>
                     <div class="w-3 h-3 rounded-full bg-yellow-500/50"></div>
                     <div class="w-3 h-3 rounded-full bg-green-500/50"></div>
                  </div>
                  <div class="h-2 w-32 bg-gray-800 rounded-full"></div>
                </div>
                <div class="p-6 grid grid-cols-3 gap-4 h-[400px]">
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">{{ $t('landing.hero.card.todo') }}</span>
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
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">{{ $t('landing.hero.card.doing') }}</span>
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
                   <div class="bg-gray-800/20 rounded-lg p-3 space-y-3">
                      <div class="flex justify-between items-center mb-2">
                         <span class="text-xs font-bold text-gray-500">{{ $t('landing.hero.card.done') }}</span>
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

      <section id="section-1" class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-[#13151D]">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
          <div class="space-y-8">
            <div class="inline-block px-4 py-1.5 rounded-full bg-blue-500/10 text-blue-400 font-bold text-xs uppercase tracking-wider border border-blue-500/20">
              {{ $t('landing.step1.badge') }}
            </div>
            
            <div class="space-y-4">
              <h2 class="text-4xl md:text-5xl font-bold text-white leading-tight">
                {{ $t('landing.step1.title_start') }}<br />
                {{ $t('landing.step1.title_end') }}
              </h2>
              <p class="text-lg text-gray-400 leading-relaxed max-w-lg">
                {{ $t('landing.step1.description') }}
              </p>
            </div>

            <div class="space-y-6 pt-2">
              <div class="flex items-start gap-4">
                <div class="flex-shrink-0 mt-1">
                  <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-pink-500 to-purple-600 flex items-center justify-center shadow-lg shadow-purple-500/20">
                     <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                  </div>
                </div>
                <div>
                  <h3 class="text-white font-bold text-lg">{{ $t('landing.step1.features.capture.title') }}</h3>
                  <p class="text-gray-400 text-sm leading-relaxed">
                    {{ $t('landing.step1.features.capture.description') }}
                  </p>
                </div>
              </div>

               <div class="flex items-start gap-4">
                <div class="flex-shrink-0 mt-1">
                  <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-500 to-cyan-600 flex items-center justify-center shadow-lg shadow-blue-500/20">
                     <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z"></path></svg>
                  </div>
                </div>
                <div>
                  <h3 class="text-white font-bold text-lg">{{ $t('landing.step1.features.unload.title') }}</h3>
                  <p class="text-gray-400 text-sm leading-relaxed">
                    {{ $t('landing.step1.features.unload.description') }}
                  </p>
                </div>
              </div>

               <div class="flex items-start gap-4">
                <div class="flex-shrink-0 mt-1">
                  <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center shadow-lg shadow-emerald-500/20">
                     <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path></svg>
                  </div>
                </div>
                <div>
                  <h3 class="text-white font-bold text-lg">{{ $t('landing.step1.features.action.title') }}</h3>
                  <p class="text-gray-400 text-sm leading-relaxed">
                    {{ $t('landing.step1.features.action.description') }}
                  </p>
                </div>
              </div>
            </div>

          </div>
          <div class="relative h-full w-full flex items-center justify-center group pointer-events-none">
             <div class="absolute inset-0 bg-gradient-to-tr from-blue-900/20 via-indigo-900/20 to-purple-900/20 blur-3xl opacity-60"></div>
             
             <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-[radial-gradient(circle_at_center,rgba(59,130,246,0.15)_0%,transparent_70%)] blur-2xl"></div>

             <div class="relative w-full h-auto flex items-center justify-center">
               <img 
                :src="_imports_0" 
                alt="Capturar" 
                class="relative w-[160%] h-auto max-w-none object-contain drop-shadow-2xl"
                style="mask-image: radial-gradient(circle at center, black 40%, transparent 95%); -webkit-mask-image: radial-gradient(circle at center, black 20%, transparent 80%);"
               >
             </div>
          </div>
        </div>
      </section>

      <section class="snap-start h-screen flex items-center justify-center p-6 md:p-12 md:px-24 bg-[#0F111A]">
        <div class="grid md:grid-cols-2 gap-12 items-center max-w-7xl mx-auto w-full">
           <div class="space-y-8">
            <div class="inline-block px-4 py-1.5 rounded-full bg-purple-500/10 text-purple-400 font-bold text-xs uppercase tracking-wider border border-purple-500/20">
              {{ $t('landing.step2.badge') }}
            </div>
            
            <div class="space-y-4">
              <h2 class="text-4xl md:text-5xl font-bold text-white leading-tight">
                {{ $t('landing.step2.title_start') }}<br />
                {{ $t('landing.step2.title_end') }}
              </h2>
              <p class="text-lg text-gray-400 leading-relaxed max-w-lg">
                {{ $t('landing.step2.description') }}
              </p>
            </div>

            <div class="space-y-5 pt-2">
               <div class="flex items-start gap-4">
                  <div class="flex-shrink-0 mt-1">
                     <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center shadow-lg shadow-green-500/20">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                     </div>
                  </div>
                  <div>
                     <h3 class="text-white font-bold text-lg">{{ $t('landing.step2.features.next_actions.title') }}</h3>
                     <p class="text-gray-400 text-sm leading-relaxed">{{ $t('landing.step2.features.next_actions.description') }}</p>
                  </div>
               </div>
               
               <div class="flex items-start gap-4">
                  <div class="flex-shrink-0 mt-1">
                     <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg shadow-blue-500/20">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                     </div>
                  </div>
                  <div>
                     <h3 class="text-white font-bold text-lg">{{ $t('landing.step2.features.projects.title') }}</h3>
                     <p class="text-gray-400 text-sm leading-relaxed">{{ $t('landing.step2.features.projects.description') }}</p>
                  </div>
               </div>

               <div class="flex items-start gap-4">
                  <div class="flex-shrink-0 mt-1">
                     <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500 to-violet-600 flex items-center justify-center shadow-lg shadow-purple-500/20">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path></svg>
                     </div>
                  </div>
                  <div>
                     <h3 class="text-white font-bold text-lg">{{ $t('landing.step2.features.waiting.title') }}</h3>
                     <p class="text-gray-400 text-sm leading-relaxed">{{ $t('landing.step2.features.waiting.description') }}</p>
                  </div>
               </div>

            </div>
          </div>

          <div class="relative h-full w-full flex items-center justify-center group pointer-events-none">
             <div class="absolute inset-0 bg-gradient-to-tr from-blue-900/20 via-indigo-900/20 to-purple-900/20 blur-3xl opacity-60"></div>
             
             <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[10%] h-[120%] bg-[radial-gradient(circle_at_center,rgba(59,130,246,0.15)_0%,transparent_70%)] blur-2xl"></div>

             <div class="relative w-full h-auto flex items-center justify-center">
               <img 
                :src="_imports_1" 
                alt="Capturar" 
                class="relative w-[140%] h-auto max-w-none object-contain drop-shadow-2xl"
                style="mask-image: radial-gradient(circle at center, black 40%, transparent 95%); -webkit-mask-image: radial-gradient(circle at center, black 20%, transparent 95%);"
               >
             </div>
          </div>
        </div>
      </section>

      <section class="snap-start h-screen flex flex-col justify-between md:p-24">
        <div class="flex-grow flex flex-col items-center justify-center w-full relative z-10 px-4 md:px-0">
          
          <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[150%] h-[150%] bg-[radial-gradient(circle_at_center,rgba(88,28,135,0.15)_0%,transparent_60%)] blur-3xl -z-10 pointer-events-none"></div>
          <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-purple-600/10 blur-[100px] rounded-full -z-10 animate-pulse"></div>
          
          <div class="max-w-6xl mx-auto w-full space-y-12">
            
            <div class="space-y-6">
              <div class="inline-block px-4 py-1.5 rounded-full bg-green-500/10 text-green-300 font-bold text-xs uppercase tracking-wider border border-green-500/20 shadow-[0_0_15px_rgba(168,85,247,0.3)]">
                {{ $t('landing.step3.badge') }}
              </div>
              <h2 class="text-center text-4xl md:text-5xl lg:text-6xl font-bold text-white leading-tight tracking-tight drop-shadow-lg">
                {{ $t('landing.step3.title_start') }} <br />
                <span class="text-transparent bg-clip-text bg-gradient-to-r from-gray-100 to-gray-400">
                  {{ $t('landing.step3.title_end') }}
                </span>
              </h2>
            </div>

            <div class="relative w-full bg-gray-900/40 backdrop-blur-xl border border-white/10 rounded-3xl p-6 md:p-10 shadow-2xl overflow-hidden ring-1 ring-white/5">
              
              <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full h-[2px] bg-gradient-to-r from-transparent via-purple-500/50 to-transparent blur-sm"></div>

              <div class="grid grid-cols-1 md:grid-cols-3 gap-6 relative z-10">
                
                <div class="space-y-4 group">
                  <div class="bg-amber-500/20 border border-amber-500/30 rounded-xl p-4 flex items-center gap-3 text-amber-100 shadow-lg shadow-amber-900/20 backdrop-blur-md transition-all duration-300 group-hover:bg-amber-500/30">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span class="font-medium">{{ $t('landing.step3.cards.time.duration') }}</span>
                    <span class="ml-auto text-amber-200/60 text-xs">✦</span>
                  </div>
                  
                  <div class="bg-amber-500/10 border border-amber-500/20 rounded-xl p-4 flex items-center gap-3 text-amber-200/80">
                     <div class="w-5 h-5 rounded border-2 border-amber-500/40 flex items-center justify-center"></div>
                     <span>{{ $t('landing.step3.cards.time.task') }}</span>
                  </div>

                  <div class="mt-8 bg-gradient-to-b from-amber-500/10 to-transparent border border-amber-500/10 rounded-2xl p-6 space-y-3 relative overflow-hidden group-hover:border-amber-500/30 transition-all">
                     <div class="absolute top-0 left-0 w-1 h-full bg-amber-500/50"></div>
                     <div class="flex items-center gap-2 text-amber-400 mb-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                        <span class="text-xs font-bold uppercase tracking-wider">{{ $t('landing.step3.cards.time.recommended') }}</span>
                     </div>
                     <p class="text-lg font-medium text-amber-100/90 leading-snug">
                       {{ $t('landing.step3.cards.time.tip') }}
                     </p>
                  </div>
                </div>

                <div class="space-y-4 group">
                  <div class="bg-emerald-500/20 border border-emerald-500/30 rounded-xl p-4 flex items-center gap-3 text-emerald-100 shadow-lg shadow-emerald-900/20 backdrop-blur-md transition-all duration-300 group-hover:bg-emerald-500/30">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span class="font-medium">{{ $t('landing.step3.cards.energy.level') }}</span>
                  </div>
                  
                  <div class="relative transform transition-transform duration-500 hover:-translate-y-2 hover:rotate-1 z-20">
                     <div class="bg-emerald-600 border border-emerald-400/50 rounded-xl p-4 flex items-center gap-3 text-white shadow-xl shadow-emerald-500/20 ring-2 ring-emerald-400/30">
                        <div class="w-5 h-5 rounded border-2 border-white/40 flex items-center justify-center">
                           <svg class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                        </div>
                        <span class="font-bold">{{ $t('landing.step3.cards.energy.task') }}</span>
                     </div>
                  </div>

                  <div class="mt-8 bg-gradient-to-b from-emerald-500/10 to-transparent border border-emerald-500/10 rounded-2xl p-6 space-y-3 relative overflow-hidden group-hover:border-emerald-500/30 transition-all">
                     <div class="absolute top-0 left-0 w-1 h-full bg-emerald-500/50"></div>
                     <div class="flex items-center gap-2 text-emerald-400 mb-2">
                         <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                        <span class="text-xs font-bold uppercase tracking-wider">{{ $t('landing.step3.cards.energy.productivity') }}</span>
                     </div>
                     <p class="text-lg font-medium text-emerald-100/90 leading-snug">
                       {{ $t('landing.step3.cards.energy.tip') }}
                     </p>
                  </div>
                </div>

                <div class="space-y-4 group">
                  <div class="bg-blue-500/20 border border-blue-500/30 rounded-xl p-4 flex items-center gap-3 text-blue-100 shadow-lg shadow-blue-900/20 backdrop-blur-md transition-all duration-300 group-hover:bg-blue-500/30">
                     <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    <span class="font-medium">{{ $t('landing.step3.cards.context.location') }}</span>
                  </div>
                  
                  <div class="bg-blue-500/10 border border-blue-500/20 rounded-xl p-4 flex items-center gap-3 text-blue-200/80">
                     <div class="w-8 h-8 rounded-full bg-orange-500/20 flex items-center justify-center mr-1">
                        <span class="text-xs text-orange-400">🌱</span>
                     </div>
                     <span>{{ $t('landing.step3.cards.context.task') }}</span>
                  </div>

                  <div class="mt-8 bg-gradient-to-b from-blue-500/10 to-transparent border border-blue-500/10 rounded-2xl p-6 space-y-3 relative overflow-hidden group-hover:border-blue-500/30 transition-all">
                     <div class="absolute top-0 left-0 w-1 h-full bg-blue-500/50"></div>
                     <div class="flex items-center gap-2 text-blue-400 mb-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                        <span class="text-xs font-bold uppercase tracking-wider">{{ $t('landing.step3.cards.context.environment') }}</span>
                     </div>
                     <p class="text-lg font-medium text-blue-100/90 leading-snug">
                       {{ $t('landing.step3.cards.context.tip') }}
                     </p>
                  </div>
                </div>
              </div>

              <div class="mt-12 relative max-w-2xl mx-auto">
                 <div class="absolute inset-0 bg-purple-500/20 blur-xl opacity-50"></div>
                 <div class="relative bg-gray-800/80 backdrop-blur-xl border border-white/10 rounded-full px-6 py-4 flex items-center gap-4 shadow-2xl">
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                    <input type="text" :placeholder="$t('landing.step3.search_placeholder')" class="bg-transparent border-none outline-none text-white placeholder-gray-500 w-full text-lg" disabled>
                    <div class="hidden sm:flex gap-2">
                       <span class="px-3 py-1 rounded-full bg-white/5 border border-white/10 text-xs text-gray-400 flex items-center gap-1">
                          <span class="w-2 h-2 rounded-full bg-purple-500"></span> {{ $t('landing.step3.tags.out') }}
                       </span>
                       <span class="px-3 py-1 rounded-full bg-white/5 border border-white/10 text-xs text-gray-400 flex items-center gap-1">
                          <span class="w-2 h-2 rounded-full bg-blue-500"></span> {{ $t('landing.step3.tags.scheduled') }}
                       </span>
                    </div>
                 </div>
              </div>
            </div>
            
          </div>
        </div>

				<footer class="w-full py-6 border-t border-gray-800 mt-8">
					<div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
						<div class="text-sm text-gray-500">
							{{ $t('landing.footer.copyright') }}
						</div>
	
						<div class="flex items-center gap-6 text-sm font-medium">
							 <router-link to="/terms" class="text-gray-500 hover:text-indigo-400 transition-colors">
								{{ $t('nav.terms') }}
							</router-link>
							<router-link to="/privacy" class="text-gray-500 hover:text-indigo-400 transition-colors">
								{{ $t('nav.privacy') }}
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
