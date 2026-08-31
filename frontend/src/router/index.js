import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '@/views/LoginView.vue'
import StudentsView from '@/views/StudentsView.vue'
import CoursesView from '@/views/CoursesView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/login',
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/students',
      name: 'students',
      component: StudentsView,
    },
    {
      path: '/courses',
      name: 'courses',
      component: CoursesView,
    },
  ],
})

export default router