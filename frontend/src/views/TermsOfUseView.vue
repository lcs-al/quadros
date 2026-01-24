<script setup>
import Navbar from '../components/common/Navbar.vue';
</script>

<template>
  <div class="min-h-screen bg-gray-50 dark:bg-[#0F111A] text-gray-900 dark:text-gray-100 font-sans">
    <Navbar />
    <div class="max-w-4xl mx-auto px-6 py-24">
      <h1 class="text-4xl font-bold mb-8 text-indigo-600 dark:text-indigo-400">Termos de Uso</h1>
      
      <div class="space-y-8 text-lg leading-relaxed text-gray-700 dark:text-gray-300">
        <p>
          Obrigado por utilizar nossa plataforma. Ao acessar ou usar nossos serviços, você concorda em cumprir estes Termos de Uso. Leia-os com atenção.
        </p>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">1. Uso Aceitável</h2>
          <p>
            Você concorda em utilizar a plataforma apenas para fins legais e de acordo com estes termos. É proibido:
          </p>
          <ul class="list-disc list-inside ml-4 mt-2 space-y-2">
            <li>Violar qualquer lei ou regulamento aplicável.</li>
            <li>Tentar violar a segurança do sistema ou acessar contas de terceiros sem autorização.</li>
            <li>Utilizar a plataforma para transmitir conteúdo nocivo, spam ou materiais ilícitos.</li>
          </ul>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">2. Responsabilidade pela Conta</h2>
          <p>
            Você é o único responsável pela segurança de suas credenciais de acesso (login e senha) e por todas as atividades que ocorram em sua conta. Recomendamos o uso de senhas fortes e a não divulgação de seus dados de acesso a terceiros. Informe-nos imediatamente sobre qualquer uso não autorizado.
          </p>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">3. Conteúdo do Usuário</h2>
          <p>
            Todo o conteúdo (textos, arquivos, dados) inserido por você na plataforma é de sua inteira responsabilidade. Você garante que possui os direitos necessários sobre o conteúdo e que ele não viola direitos de propriedade intelectual ou privacidade de terceiros.
          </p>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">4. Disponibilidade e Alterações</h2>
          <p>
            Trabalhamos para manter a plataforma disponível e segura, mas não garantimos que o serviço será ininterrupto ou livre de erros. Reservamo-nos o direito de:
          </p>
          <ul class="list-disc list-inside ml-4 mt-2 space-y-2">
            <li>Alterar, suspender ou descontinuar funcionalidades a qualquer momento.</li>
            <li>Realizar manutenções que possam causar indisponibilidade temporária.</li>
          </ul>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">5. Encerramento de Conta</h2>
          <p>
            Podemos suspender ou encerrar sua conta a qualquer momento, mediante aviso prévio razoável ou imediatamente em caso de violação grave destes Termos de Uso ou uso indevido da plataforma.
          </p>
        </section>

        <section>
          <h2 class="text-2xl font-semibold mb-4 text-gray-900 dark:text-white">6. Contato</h2>
          <p>
            Se você tiver dúvidas sobre estes Termos de Uso, entre em contato conosco através dos nossos canais de suporte.
          </p>
        </section>
      </div>
    </div>
  </div>
</template>
