import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import LoginView from '@/views/LoginView.vue';
import StudentsView from '@/views/StudentsView.vue';
import CoursesView from '@/views/CoursesView.vue';
import StudentProfile from '@/views/StudentProfile.vue'

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
    path: "/profile",
    component: StudentProfile,
    meta: {
      requiresAuth: true,
      roles: ["student"]
    }
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

router.beforeEach((to) => {
  const authStore = useAuthStore();

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return { path: "/login" };
  }

  if (to.path === "/login" && authStore.isAuthenticated) {
    if (to.path === "/login" && authStore.isAuthenticated) {
      if (authStore.role === "admin" || authStore.role === "teacher") {
        return { path: "/students" };
      }

      return { path: "/profile" };
    }
  }

  if (to.meta.roles && !to.meta.roles.includes(authStore.role)) {
    return { path: "/courses" };
  }
});

export default router;