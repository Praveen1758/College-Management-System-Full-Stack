<template>
  <div id="app">
    <!-- Navbar displayed only when user is logged in -->
    <nav v-if="authStore.isAuthenticated" class="navbar">
      <div class="nav-brand">College Management System</div>
      <div class="nav-links">
        <router-link to="/students">Students</router-link>
        <router-link to="/courses">Courses</router-link>
        <router-link v-if="authStore.isAdmin" to="/enrollments">Enrollment</router-link>
        <button @click="handleLogout" class="btn-logout">Logout</button>
      </div>
    </nav>

    <!-- Main Router Content -->
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()

const handleLogout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

<style>
/* Global Layout Styles */
body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
  background-color: #f4f6f8;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #1e293b;
  padding: 15px 30px;
  color: white;
}

.nav-brand {
  font-weight: bold;
  font-size: 1.2rem;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 20px;
}

.nav-links a {
  color: #cbd5e1;
  text-decoration: none;
  font-weight: 500;
}

.nav-links a.router-link-active {
  color: #ffffff;
  border-bottom: 2px solid #38bdf8;
}

.btn-logout {
  background-color: #ef4444;
  color: white;
  border: none;
  padding: 6px 14px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-logout:hover {
  background-color: #dc2626;
}

.main-content {
  padding: 20px;
}
</style>