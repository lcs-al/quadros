<template>
  <!-- Main Container with Cosmic Background -->
  <div class="min-h-screen w-full flex items-center justify-center relative overflow-hidden">
    
    <!-- Cosmic Background Effects -->
    <div class="absolute inset-0 w-full h-full z-0">
       <!-- Radial Gradient Center (Purple/Amber glow) -->
       <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-[radial-gradient(ellipse_at_center,rgba(186,28,135,0.15)_0%,transparent_70%)] blur-3xl"></div>
       
       <!-- Floating Orbs/Elements (Stylized representations of the image elements) -->
       <!-- Top Left: Notification Bell Area -->
       <div class="absolute top-1/4 left-[18%] w-18 h-18 bg-gradient-to-br from-orange-400/20 to-red-500/20 rounded-full blur-xl animate-float-slow"></div>
       
       <!-- Top Right: Success Check Area -->
       <div class="absolute top-[20%] right-[15%] w-24 h-24 bg-gradient-to-br from-green-400/20 to-emerald-600/20 rounded-full blur-2xl animate-float-delayed"></div>

       <!-- Bottom Right: List/Task Area -->
       <div class="absolute bottom-[20%] right-[20%] w-24 h-24 bg-gradient-to-tr from-blue-500/10 to-indigo-600/10 rounded-full blur-2xl animate-pulse-slow"></div>
    </div>

    <!-- Floating 3D Elements (Visual Decoration) -->
    <!-- Bell Icon (Top Left) -->
    <div class="absolute top-[25%] left-[18%] hidden lg:block animate-float">
        <div class="relative w-12 h-12 flex items-center justify-center text-orange-400 drop-shadow-[0_0_15px_rgba(251,146,60,0.5)]">
            <font-awesome-icon icon="bell" class="text-4xl transform rotate-12" />
            <div class="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full border border-[#0F111A]"></div>
        </div>
    </div>

    <!-- Check Icon (Top Right) -->
    <div class="absolute top-[18%] right-[18%] hidden lg:block animate-float-delayed">
        <div class="relative w-16 h-16 rounded-full bg-gradient-to-br from-green-400 to-emerald-600 flex items-center justify-center shadow-[0_0_30px_rgba(34,197,94,0.4)] ring-4 ring-green-500/20">
            <font-awesome-icon icon="check" class="text-3xl text-white" />
        </div>
    </div>

    <!-- Rocket (Right Side) -->
    <div class="absolute bottom-[35%] right-[25%] hidden lg:block animate-launch">
         <font-awesome-icon icon="rocket" class="text-4xl bg-clip-text bg-gradient-to-r from-orange-500 to-red-500 transform rotate-45 drop-shadow-lg" />
    </div>

    <!-- List Card (Bottom Right) -->
    <div class="absolute bottom-[20%] right-[15%] hidden lg:block animate-float-slow opacity-80">
        <div class="bg-white/10 backdrop-blur-md p-4 rounded-xl border border-white/10 transform rotate-12 shadow-2xl w-32">
            <div class="h-2 w-16 bg-white/20 rounded mb-3"></div>
            <div class="space-y-2">
                <div class="flex items-center gap-2">
                    <div class="w-3 h-3 bg-blue-500 rounded-sm"></div>
                    <div class="h-1.5 w-full bg-white/10 rounded"></div>
                </div>
                 <div class="flex items-center gap-2">
                    <div class="w-3 h-3 bg-green-500 rounded-sm"></div>
                    <div class="h-1.5 w-full bg-white/10 rounded"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Navbar Overlay (Fixed) -->
    <Navbar />

    <!-- Glassmorphism Login Card -->
    <div class="relative z-10 w-full max-w-md mx-auto p-6 md:p-0">
      <div class="bg-gray-900/40 backdrop-blur-xl border border-white/10 rounded-3xl overflow-hidden shadow-2xl ring-1 ring-white/5 p-8 md:p-10">
        
        <!-- Logo Grid -->
        <div class="flex flex-col items-center justify-center mb-8">
          <div class="grid grid-cols-2 grid-rows-2 gap-1 rounded-2xl shadow-lg border border-white/10 p-1 bg-white/5 mb-6">
            <div class="flex items-center justify-center w-10 h-10 bg-[#2D3748] rounded-tl-xl text-white/80">
              <font-awesome-icon icon="th-large" class="text-sm" />
            </div>
            <div class="flex items-center justify-center w-10 h-10 bg-[#10B981] rounded-tr-xl text-white">
              <font-awesome-icon icon="check" class="text-sm" />
            </div>
             <div class="flex items-center justify-center w-10 h-10 bg-[#F97316] rounded-bl-xl text-white">
              <font-awesome-icon icon="clock" class="text-sm" />
            </div>
            <div class="flex items-center justify-center w-10 h-10 bg-[#7C3AED] rounded-br-xl text-white">
              <font-awesome-icon icon="user-circle" class="text-sm" />
            </div>
          </div>

          <!-- Headings -->
          <div class="text-center space-y-2">
             <h2 class="text-2xl md:text-3xl font-bold text-white tracking-tight">
               {{ $t('auth.login.title') }}
             </h2>
             <p class="text-gray-400 font-medium">
               {{ $t('auth.login.subtitle') }}
             </p>
          </div>
        </div>

        <!-- Form -->
        <form class="space-y-5" @submit.prevent="handleLogin">
          
          <!-- Email Input -->
          <div class="space-y-1">
             <div class="relative group">
                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-gray-500 group-focus-within:text-indigo-400 transition-colors">
                  <font-awesome-icon icon="envelope" />
                </div>
                <input
                  v-model="email"
                  id="email-address"
                  name="email"
                  type="email"
                  autocomplete="email"
                  required
                  class="w-full pl-11 pr-4 py-3.5 bg-gray-800/50 border border-gray-700/50 rounded-xl text-gray-100 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 focus:border-indigo-500/50 focus:bg-gray-800 transition-all font-medium sm:text-sm"
                  :placeholder="$t('auth.login.email_placeholder')"
                />
             </div>
          </div>

          <!-- Password Input -->
          <div class="space-y-1">
             <div class="relative group">
                 <input
                  v-model="password"
                  id="password"
                  name="password"
                  :type="showPassword ? 'text' : 'password'"
                  autocomplete="current-password"
                  required
                  class="w-full pl-4 pr-11 py-3.5 bg-gray-800/50 border border-gray-700/50 rounded-xl text-gray-100 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 focus:border-indigo-500/50 focus:bg-gray-800 transition-all font-medium sm:text-sm tracking-widest"
                  placeholder="••••••••"
                />
                <div class="absolute inset-y-0 right-0 pr-4 flex items-center">
                  <button 
                    type="button"
                    @click="showPassword = !showPassword"
                    class="text-gray-500 hover:text-gray-300 focus:outline-none cursor-pointer transition-colors"
                  >
                    <font-awesome-icon :icon="showPassword ? 'eye-slash' : 'eye'" />
                  </button>
                </div>
             </div>
             
             <!-- Forgot Password Link Area -->
             <div class="flex justify-start py-1 pb-4">
                <div class="text-right space-y-0.5">
                   <a href="#" class="text-xs text-gray-400 hover:text-white transition-colors block">
                     {{ $t('auth.login.forgot_password') }}
                   </a>
                </div>
             </div>
          </div>

          <!-- Submit Button -->
          <button
              type="submit"
              :disabled="loading"
              class="cursor-pointer w-full py-3.5 px-4 bg-gradient-to-r from-blue-600 to-indigo-600 hover:to-indigo-500 text-white font-bold rounded-xl shadow-lg shadow-indigo-500/20 transform hover:-translate-y-0.5 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-900 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
             <span v-if="!loading">{{ $t('auth.login.submit') }}</span>
             <span v-else class="flex items-center justify-center gap-2">
               <svg class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                 <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                 <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
               </svg>
               Carregando...
             </span>
          </button>

          <!-- Error Message -->
          <div v-if="error" class="bg-red-500/10 border border-red-500/20 rounded-lg p-3 text-red-400 text-sm text-center">
             {{ error }}
          </div>

          <!-- Register Link -->
          <div class="text-center pt-2">
             <p class="text-gray-500 text-sm">
               {{ $t('auth.login.no_account') }}
							 <br/>
               <router-link to="/register" class="text-indigo-400 hover:text-indigo-300 font-medium underline-offset-4 hover:underline transition-all ml-1">
                 {{ $t('auth.login.create_account') }}
               </router-link>
             </p>
          </div>
        </form>

        <!-- Footer / Lock Icon -->
         <div class="mt-8 text-center space-y-2">
             <div class="flex items-center justify-center gap-2 text-gray-200/60 text-xs">
                <font-awesome-icon icon="lock" />
                <span>{{ $t('auth.login.security_notice') }}</span>
             </div>
             
             <div class="flex items-center justify-center gap-1 text-[11px] text-gray-200/60">
                <router-link to="/terms" class="hover:text-gray-100 transition-colors">{{ $t('auth.login.terms') }}</router-link>
                <span>&</span>
                <router-link to="/privacy" class="hover:text-gray-100 transition-colors">{{ $t('auth.login.privacy') }}</router-link>
             </div>
         </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import Navbar from '../components/common/Navbar.vue';

const { t } = useI18n();
const email = ref('admin@example.com');
const password = ref('password');
const showPassword = ref(false);
const error = ref('');
const loading = ref(false);
const authStore = useAuthStore();
const router = useRouter();

const handleLogin = async () => {
  error.value = '';
  loading.value = true;
  // Simulate network delay for effect if needed, but keeping it real
  try {
    const success = await authStore.login(email.value, password.value);
    if (success) {
      router.push('/');
    } else {
      error.value = t('auth.error.invalid_credentials');
    }
  } catch (e) {
      error.value = t('auth.error.invalid_credentials');
  } finally {
      loading.value = false;
  }
};
</script>

<style scoped>
/* Custom animations for the floating elements */
@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0); }
  50% { transform: translateY(-20px) rotate(5deg); }
}

@keyframes float-delayed {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

@keyframes float-slow {
  0%, 100% { transform: translateY(0) rotate(12deg); }
  50% { transform: translateY(-30px) rotate(15deg); }
}

@keyframes launch {
    0% { transform: translate(0, 0) rotate(45deg); }
    100% { transform: translate(10px, -10px) rotate(45deg); }
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

.animate-float-delayed {
  animation: float-delayed 7s ease-in-out infinite 2s;
}

.animate-float-slow {
  animation: float-slow 10s ease-in-out infinite;
}

.animate-launch {
    animation: launch 2s ease-in-out infinite alternate;
}
</style>
