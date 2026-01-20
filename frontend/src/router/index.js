import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import i18n from "../i18n";
import RegisterView from '../views/RegisterView.vue';

const routes = [
	{
		path: "/login",
		name: "Login",
		component: () => import("../views/LoginView.vue"),
		meta: { guest: true, title: "auth.login.title" },
	},
	{
		path: "/",
		name: "Landing",
		component: () => import("../views/LandingPage.vue"),
		meta: { guest: true, title: "app.home" },
	},
	{
		path: "/register",
		name: "Register",
		component: RegisterView,
		meta: { guest: true, title: "auth.register.title" },
	},
	{
		path: "/privacy",
		name: "PrivacyPolicy",
		component: () => import("../views/PrivacyPolicyView.vue"),
		meta: { title: "Política de Privacidade" },
	},
	{
		path: "/terms",
		name: "TermsOfUse",
		component: () => import("../views/TermsOfUseView.vue"),
		meta: { title: "Termos de Uso" },
	},
	{
		path: "/boards",
		name: "BoardsList",
		component: () => import("../views/BoardsListView.vue"),
		meta: { requiresAuth: true, title: "nav.boards" },
	},
	{
		path: "/boards/:id",
		name: "BoardEdit",
		component: () => import("../views/BoardEditView.vue"),
		meta: { requiresAuth: true, title: "board.edit" },
	},
	{
		path: "/boards/:id/backlog",
		name: "BoardBacklog",
		component: () => import("../views/BacklogView.vue"),
		meta: { requiresAuth: true, title: "board.backlog.title" },
	},
	{
		path: "/profile",
		name: "Profile",
		component: () => import("../views/ProfileView.vue"),
		meta: { requiresAuth: true, title: "nav.profile" },
	},
	{
		path: "/reports",
		name: "Reports",
		component: {
			template: '<div class="p-8"><h1>Relatórios (Em breve)</h1></div>',
		},
		meta: { requiresAuth: true, title: "nav.reports" },
	},
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next("/login");
  } else if (to.path === "/" && authStore.isAuthenticated) {
    next("/boards");
  } else if (to.meta.guest && authStore.isAuthenticated && to.path !== "/") {
    next("/boards");
  } else {
    next();
  }
});

router.afterEach((to) => {
  const { t } = i18n.global;
  const baseTitle = t("app.name") || "Quadros";
  const pageTitleKey = to.meta.title;

  if (pageTitleKey) {
    document.title = `${baseTitle} | ${t(pageTitleKey)}`;
  } else {
    document.title = baseTitle;
  }
});

export default router;
