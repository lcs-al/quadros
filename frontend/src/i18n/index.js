import { createI18n } from 'vue-i18n';
import en from '../locales/en.json';
import pt_BR from '../locales/pt_BR.json';

const i18n = createI18n({
  legacy: false, // Use Composition API
  locale: 'pt_BR',
  fallbackLocale: 'en',
  messages: {
    en,
    pt_BR
  }
});

export default i18n;
