import { defineStore } from 'pinia';
import api from '@/services/api';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('jwt_token') || '',
    user: JSON.parse(localStorage.getItem('user')) || null,
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,
    role: (state) => state.user?.role || 'student',
    isAdmin: (state) => state.user?.role === 'admin',
    isTeacher: (state) => state.user?.role === 'teacher',
    isStudent: (state) => state.user?.role === 'student'
  },

  actions: {
    async login(credentials) {
      try {
        // Pass credentials directly: { email: credentials.email, password: credentials.password }
        const response = await api.post('/auth/login', {
          email: credentials.email,
          password: credentials.password
        });

        const { token, user } = response.data;

        this.token = token;
        this.user = user;

        localStorage.setItem('jwt_token', token);
        localStorage.setItem('user', JSON.stringify(user));

        api.defaults.headers.common['Authorization'] = `Bearer ${token}`;

        return user;
      } catch (error) {
        throw error.response?.data?.error || 'Invalid email or password.';
      }
    },

    logout() {
      this.token = '';
      this.user = null;
      localStorage.removeItem('jwt_token');
      localStorage.removeItem('user');
      delete api.defaults.headers.common['Authorization'];
    }
  }
});