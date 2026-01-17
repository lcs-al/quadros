<script setup>
import Navbar from '../components/common/Navbar.vue';
</script>

<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 font-sans">
    <Navbar />
    <div class="max-w-4xl mx-auto px-6 py-24">
      <h1 class="text-4xl font-bold mb-8 text-indigo-600 dark:text-indigo-400">Política de Privacidade</h1>
      
      <div class="space-y-8 text-lg leading-relaxed text-gray-700 dark:text-gray-300">
        <p>
          Sua privacidade é importante para nós. Esta política explica de forma clara como coletamos, usamos e protegemos suas informações ao utilizar nossa plataforma.
        </p>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">1. Coleta de Dados</h2>
          <p>
            Coletamos apenas os dados essenciais para o funcionamento e melhoria da plataforma:
          </p>
          <ul class="list-disc list-inside ml-4 mt-2 space-y-2">
            <li><strong>Informações de Cadastro:</strong> Nome, e-mail e credenciais de acesso para criação da sua conta.</li>
            <li><strong>Dados de Uso:</strong> Informações sobre como você interage com o sistema (ex: quadros criados, atividades), para personalização e suporte.</li>
            <li><strong>Informações Técnicas:</strong> Endereço IP, tipo de navegador, dispositivo e logs de acesso, para fins de segurança e diagnóstico.</li>
          </ul>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">2. Uso das Informações</h2>
          <p>
            Utilizamos seus dados estritamente para:
          </p>
          <ul class="list-disc list-inside ml-4 mt-2 space-y-2">
            <li>Garantir o funcionamento correto de todas as funcionalidades da plataforma.</li>
            <li>Analisar padrões de uso para otimizar o desempenho e a experiência do usuário.</li>
            <li>Detectar e prevenir fraudes ou abusos.</li>
            <li>Comunicar atualizações importantes ou responder a solicitações de suporte.</li>
          </ul>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">3. Compartilhamento de Dados</h2>
          <p>
            Temos um compromisso sério com a proteção dos seus dados. <strong>Não vendemos, não alugamos e não compartilhamos</strong> suas informações pessoais com terceiros para fins comerciais.
          </p>
          <p class="mt-2">
            O compartilhamento ocorrerá apenas se:
          </p>
          <ul class="list-disc list-inside ml-4 mt-2 space-y-2">
            <li>For estritamente necessário para a prestação do serviço (ex: provedores de infraestrutura de nuvem confiáveis).</li>
            <li>For exigido por lei ou ordem judicial.</li>
          </ul>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">4. Segurança</h2>
          <p>
            Adotamos medidas de segurança técnicas e administrativas robustas para proteger seus dados contra acesso não autorizado, alteração, divulgação ou destruição. Utilizamos criptografia e protocolos seguros em todas as etapas do processamento.
          </p>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">5. Atualizações</h2>
          <p>
            Podemos atualizar esta Política de Privacidade periodicamente para refletir melhorias na plataforma ou mudanças na legislação. Recomendamos que você revise este documento regularmente. O uso continuado da plataforma após as alterações indica sua concordância com os novos termos.
          </p>
        </section>
      </div>
    </div>
  </div>
</template>
