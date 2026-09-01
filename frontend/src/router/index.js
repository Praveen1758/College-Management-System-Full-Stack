import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import LoginView from '@/views/LoginView.vue';
import StudentsView from '@/views/StudentsView.vue';
import CoursesView from '@/views/CoursesView.vue';

const routes = [
  { 
    path: '/login', 
    name: 'login', 
    component: LoginView 
  },
  { 
    path: '/students', 
    name: 'students', 
    component: StudentsView, 
    meta: { requiresAuth: true, roles: ['admin', 'teacher'] } 
  },
  { 
    path: '/courses', 
    name: 'courses', 
    component: CoursesView, 
    meta: { requiresAuth: true, roles: ['admin', 'teacher', 'student'] } 
  },
  { 
    path: '/:pathMatch(.*)*', 
    redirect: '/login' 
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from) => {
  const authStore = useAuthStore();

  // 1. If route requires auth and user is NOT logged in
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    if (to.path !== '/login') {
      return { path: '/login' }; // Stop infinite loop
    }
  }

  // 2. If user is already logged in and tries to access /login
  if (to.path === '/login' && authStore.isAuthenticated) {
    if (authStore.userRole === 'admin' || authStore.userRole === 'teacher') {
      return { path: '/students' };
    }
    return { path: '/courses' };
  }

  // 3. Role-based access restriction
  if (to.meta.roles && !to.meta.roles.includes(authStore.userRole)) {
    return { path: '/courses' };
  }
});

export default router;