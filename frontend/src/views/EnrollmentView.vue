<template>
  <div class="enroll-container">
    <h2>Course Enrollment</h2>
    <p class="subtitle">Enroll a student into an active course</p>

    <p v-if="message" class="success-msg">{{ message }}</p>
    <p v-if="error" class="error-msg">{{ error }}</p>

    <form @submit.prevent="handleEnrollment">
      <div class="form-group">
        <label>Select Student</label>
        <select v-model="selectedStudentId" required>
          <option value="" disabled>-- Choose Student --</option>
          <option v-for="student in students" :key="student.id" :value="student.id">
            {{ student.name }} ({{ student.email }})
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>Select Course</label>
        <select v-model="selectedCourseId" required>
          <option value="" disabled>-- Choose Course --</option>
          <option v-for="course in courses" :key="course.id" :value="course.id">
            {{ course.name }}
          </option>
        </select>
      </div>

      <button type="submit" class="btn-submit" :disabled="loading">
        {{ loading ? 'Enrolling...' : 'Submit Enrollment' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '@/services/api';

const students = ref([]);
const courses = ref([]);
const selectedStudentId = ref('');
const selectedCourseId = ref('');
const loading = ref(false);
const message = ref('');
const error = ref('');

const loadData = async () => {
  try {
    const [resStudents, resCourses] = await Promise.all([
      api.get('/students'),
      api.get('/courses')
    ]);
    students.value = Array.isArray(resStudents.data) ? resStudents.data : resStudents.data.data || [];
    courses.value = Array.isArray(resCourses.data) ? resCourses.data : resCourses.data.data || [];
  } catch (err) {
    console.error('Failed to load students/courses:', err);
  }
};

const handleEnrollment = async () => {
  loading.value = true;
  message.value = '';
  error.value = '';

  try {
    await api.post('/enrollments', {
      enrollment: {
        student_id: selectedStudentId.value,
        course_id: selectedCourseId.value
      }
    });
    message.value = 'Student enrolled successfully! Confirmation email queued.';
    selectedStudentId.value = '';
    selectedCourseId.value = '';
  } catch (err) {
    error.value = err.response?.data?.error || 'Failed to complete enrollment.';
  } finally {
    loading.value = false;
  }
};

onMounted(loadData);
</script>

<style scoped>
.enroll-container { max-width: 500px; margin: 40px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.subtitle { color: #64748b; margin-bottom: 20px; }
.form-group { display: flex; flex-direction: column; margin-bottom: 15px; }
.form-group label { font-weight: bold; margin-bottom: 5px; }
.form-group select { padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px; }
.btn-submit { width: 100%; padding: 10px; background: #2563eb; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
.success-msg { color: #16a34a; font-weight: bold; margin-bottom: 15px; }
.error-msg { color: #dc2626; font-weight: bold; margin-bottom: 15px; }
</style>