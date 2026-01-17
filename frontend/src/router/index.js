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
    redirect: "/boards",
  },
  {
    path: '/register',
    name: 'Register',
    component: RegisterView,
    meta: { guest: true, title: 'auth.register.title' }
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
    path: "/profile",
    name: "Profile",
    component: () => import("../views/ProfileView.vue"),
    meta: { requiresAuth: true, title: "nav.profile" },
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
