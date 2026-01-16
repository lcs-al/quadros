import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import i18n from "../i18n";

const routes = [
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/LoginView.vue"),
    meta: { guest: true, title: "auth.login.title" },
  },
  {
    path: "/",
    name: "Dashboard",
    component: () => import("../views/DashboardView.vue"),
    meta: { requiresAuth: true, title: "nav.dashboard" },
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
  } else if (to.meta.guest && authStore.isAuthenticated) {
    next("/");
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
