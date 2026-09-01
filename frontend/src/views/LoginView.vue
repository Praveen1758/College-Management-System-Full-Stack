<template>
  <div class="login-container">
    <div class="login-card">
      <h2>College Management System</h2>
      <p class="subtitle">Sign in to your account</p>

      <div v-if="errorMessage" class="error-alert">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="email">Email Address</label>
          <input 
            type="email" 
            id="email" 
            v-model="email" 
            required 
            placeholder="student@example.com"
          />
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <div class="password-input-wrapper">
            <input 
              :type="showPassword ? 'text' : 'password'" 
              id="password" 
              v-model="password" 
              required 
              placeholder="••••••••"
            />
            <button 
              type="button" 
              class="toggle-password-btn" 
              @click="showPassword = !showPassword"
              tabindex="-1"
            >
              {{ showPassword ? 'Hide' : 'Show' }}
            </button>
          </div>
        </div>

        <button type="submit" :disabled="loading" class="btn-login">
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();
const authStore = useAuthStore();

const email = ref('student@example.com');
const password = ref('');
const showPassword = ref(false);
const errorMessage = ref('');
const loading = ref(false);

const handleLogin = async () => {
  loading.value = true;
  errorMessage.value = '';

  try {
    const user = await authStore.login({
      email: email.value,
      password: password.value
    });

    if (user.role === 'admin' || user.role === 'teacher') {
      router.push('/students');
    } else {
      router.push('/courses');
    }
  } catch (err) {
    errorMessage.value = typeof err === 'string' ? err : (err?.response?.data?.error || 'Invalid email or password.');
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
}

.login-card {
  background: white;
  padding: 40px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.subtitle {
  color: #64748b;
  margin-bottom: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
}

.form-group label {
  margin-bottom: 6px;
  font-weight: 600;
  font-size: 0.9rem;
}

.password-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.password-input-wrapper input {
  width: 100%;
  padding: 10px;
  padding-right: 60px;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
}

.toggle-password-btn {
  position: absolute;
  right: 10px;
  background: none;
  border: none;
  color: #2563eb;
  font-weight: 600;
  font-size: 0.8rem;
  cursor: pointer;
}

.btn-login {
  width: 100%;
  padding: 10px;
  background-color: #2563eb;
  color: white;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 10px;
}

.btn-login:disabled {
  background-color: #94a3b8;
}

.error-alert {
  background-color: #fef2f2;
  color: #ef4444;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
  font-size: 0.9rem;
}
</style>