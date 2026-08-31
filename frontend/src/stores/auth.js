import { defineStore } from 'pinia';
import api from '@/services/api';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('jwt_token') || ''
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
    role: (state) => state.user?.role || 'student',
    isAdmin: (state) => state.user?.role === 'admin',
    isTeacher: (state) => state.user?.role === 'teacher',
    isStudent: (state) => state.user?.role === 'student'
  },
  actions: {
    async login(email, password) {
      const response = await api.post('/auth/login', {
        user: { email, password },
        email,
        password
      });

      const token = response.data.token || response.data.jwt;
      const user = response.data.user || response.data.data;

      this.token = token;
      this.user = user;

      localStorage.setItem('jwt_token', token);
      localStorage.setItem('user', JSON.stringify(user));
    },
    logout() {
      this.token = '';
      this.user = null;
      localStorage.removeItem('jwt_token');
      localStorage.removeItem('user');
    }
  }
});