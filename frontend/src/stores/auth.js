import { defineStore } from 'pinia';
import api from '../api';

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: JSON.parse(localStorage.getItem("user")) || null,
    token: localStorage.getItem("token") || null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
    isAdmin: (state) => state.user?.role === "admin",
  },
  actions: {
    async login(email, password) {
      try {
        const response = await api.post("/auth/login", {
          auth: { email, password },
        });
        this.token = response.data.token;
        this.user = response.data.user;
        localStorage.setItem("token", this.token);
        localStorage.setItem("user", JSON.stringify(this.user));
        return true;
      } catch (error) {
        console.error("Login failed", error);
        return false;
      }
    },
    async signup(payload) {
      try {
        const isFormData = payload instanceof FormData;
        const headers = isFormData ? { "Content-Type": "multipart/form-data" } : {};

        const response = await api.post("/auth/signup", payload, { headers });

        this.token = response.data.token;
        this.user = response.data.user;
        localStorage.setItem("token", this.token);
        localStorage.setItem("user", JSON.stringify(this.user));
        return { success: true };
      } catch (error) {
        console.error("Signup failed", error);
        return {
          success: false,
          errors: error.response?.data?.errors || ["An error occurred"]
        };
      }
    },
    async updateProfile(formData) {
      try {
        const response = await api.patch("/users/update_profile", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });
        this.user = response.data;
        localStorage.setItem("user", JSON.stringify(this.user));
        return { success: true };
      } catch (error) {
        console.error("Update profile failed", error);
        return {
          success: false,
          errors: error.response?.data?.errors || ["An error occurred"],
        };
      }
    },
    async fetchMe() {
      try {
        const response = await api.get("/users/me");
        this.user = response.data;
        localStorage.setItem("user", JSON.stringify(this.user));
      } catch (error) {
        console.error("Fetch me failed", error);
      }
    },
    logout() {
      this.token = null;
      this.user = null;
      localStorage.removeItem("token");
      localStorage.removeItem("user");
    },
  },
});
