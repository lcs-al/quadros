import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import i18n from './i18n'
import './style.css'
import App from './App.vue'

/* Font Awesome */
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import {
  faBell,
  faCog,
  faChevronDown,
  faSun,
  faMoon,
  faSignOutAlt,
  faPlus,
  faTrashAlt,
  faTimes,
  faColumns,
  faSpinner,
  faThLarge,
  faCheck,
  faClock,
  faUserCircle,
  faEnvelope,
  faEye,
  faEyeSlash,
  faComment,
  faAlignLeft,
} from "@fortawesome/free-solid-svg-icons";

library.add(
  faBell,
  faCog,
  faChevronDown,
  faSun,
  faMoon,
  faSignOutAlt,
  faPlus,
  faTrashAlt,
  faTimes,
  faColumns,
  faSpinner,
  faThLarge,
  faCheck,
  faClock,
  faUserCircle,
  faEnvelope,
  faEye,
  faEyeSlash,
  faComment,
  faAlignLeft
);

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(i18n)

app.component("font-awesome-icon", FontAwesomeIcon);
app.mount('#app')

