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
	faUndo,
	faCamera,
	faCheckCircle,
	faExclamationCircle,
	faPencilAlt,
	faArrowLeft,
	faChevronLeft,
	faChevronRight,
	faChartPie,
	faUser,
	faUsers,
	faBars,
	faBookmark,
	faEllipsisH,
	faArchive,
	faCheckSquare,
	faBug,
	faClipboardList,
	faArrowRight,
} from "@fortawesome/free-solid-svg-icons";
import {
	faGithub,
	faLinkedin
} from "@fortawesome/free-brands-svg-icons";

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
	faAlignLeft,
	faUndo,
	faCamera,
	faCheckCircle,
	faExclamationCircle,
	faPencilAlt,
	faArrowLeft,
	faChevronLeft,
	faChevronRight,
	faChartPie,
	faUser,
	faUsers,
	faBars,
	faBookmark,
	faEllipsisH,
	faArchive,
	faCheckSquare,
	faBug,
	faClipboardList,
	faGithub,
	faLinkedin,
	faArrowRight,
);

const app = createApp(App)

app.directive("click-outside", {
	mounted(el, binding) {
		el.clickOutsideEvent = function (event) {
			if (!(el === event.target || el.contains(event.target))) {
				binding.value(event);
			}
		};
		document.body.addEventListener("click", el.clickOutsideEvent);
	},
	unmounted(el) {
		document.body.removeEventListener("click", el.clickOutsideEvent);
	},
});

app.use(createPinia())
app.use(router)
app.use(i18n)

app.component("font-awesome-icon", FontAwesomeIcon);
app.mount('#app')

