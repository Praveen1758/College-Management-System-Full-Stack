<template>
  <div class="view-container">
    <div class="header-section">
      <h2>Courses Directory</h2>
      <button v-if="authStore.isAdmin" @click="openModal()" class="btn-primary">+ Add Course</button>
    </div>

    <!-- Courses List -->
    <div v-if="courses.length" class="courses-grid">
      <div v-for="course in courses" :key="course.id" class="course-card">
        <div class="card-header">
          <h3>{{ course.name }}</h3>
          <div v-if="authStore.isAdmin" class="card-actions">
            <button @click="openModal(course)" class="btn-edit">Edit</button>
            <button @click="deleteCourse(course.id)" class="btn-delete">Delete</button>
          </div>
        </div>

        <p class="description">{{ course.description || 'No description provided.' }}</p>

        <!-- Enrolled Students Section -->
        <div class="enrolled-section">
          <h4>Enrolled Students ({{ course.students?.length || 0 }})</h4>
          <ul v-if="course.students && course.students.length" class="student-list">
            <li v-for="student in course.students" :key="student.id">
              {{ student.name }} <span class="student-email">({{ student.email }})</span>
            </li>
          </ul>
          <p v-else class="no-enrolled">No students enrolled yet.</p>
        </div>
      </div>
    </div>

    <p v-else class="empty-state">No courses found.</p>

    <!-- Modal Form (Create / Edit Course) -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <h3>{{ isEditing ? 'Edit Course' : 'Add New Course' }}</h3>
        <form @submit.prevent="saveCourse">
          <div class="form-group">
            <label>Course Name</label>
            <input v-model="form.name" required placeholder="e.g. Computer Science 101" />
          </div>
          <div class="form-group">
            <label>Description</label>
            <textarea v-model="form.description" rows="4" placeholder="Course syllabus and details..."></textarea>
          </div>
          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn-secondary">Cancel</button>
            <button type="submit" class="btn-primary">Save Course</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '@/services/api';
import { useAuthStore } from '@/stores/auth';

const authStore = useAuthStore();
const courses = ref([]);
const showModal = ref(false);
const isEditing = ref(false);

const form = ref({
  id: null,
  name: '',
  description: ''
});

const fetchCourses = async () => {
  try {
    const response = await api.get('/courses');
    courses.value = Array.isArray(response.data) ? response.data : response.data.data || [];
  } catch (err) {
    console.error('Failed to load courses:', err);
  }
};

const openModal = (course = null) => {
  if (course) {
    isEditing.value = true;
    form.value = { id: course.id, name: course.name, description: course.description };
  } else {
    isEditing.value = false;
    form.value = { id: null, name: '', description: '' };
  }
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
};

const saveCourse = async () => {
  try {
    if (isEditing.value) {
      await api.put(`/courses/${form.value.id}`, { course: form.value });
    } else {
      await api.post('/courses', { course: form.value });
    }
    closeModal();
    fetchCourses();
  } catch (err) {
    alert(err.response?.data?.error || 'Failed to save course record.');
  }
};

const deleteCourse = async (id) => {
  if (!confirm('Are you sure you want to delete this course?')) return;
  try {
    await api.delete(`/courses/${id}`);
    fetchCourses();
  } catch (err) {
    alert(err.response?.data?.error || 'Failed to delete course.');
  }
};

onMounted(fetchCourses);
</script>

<style scoped>
.view-container { max-width: 900px; margin: 30px auto; padding: 20px; }
.header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.courses-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 20px; }
.course-card { background: white; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
.card-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f1f5f9; padding-bottom: 10px; }
.card-header h3 { margin: 0; color: #0f172a; }
.card-actions { display: flex; gap: 6px; }
.description { color: #475569; margin: 15px 0; font-size: 0.95rem; }
.enrolled-section { background: #f8fafc; padding: 12px; border-radius: 6px; }
.enrolled-section h4 { margin: 0 0 8px 0; font-size: 0.9rem; color: #334155; }
.student-list { margin: 0; padding-left: 20px; font-size: 0.85rem; color: #1e293b; }
.student-email { color: #64748b; }
.no-enrolled { font-size: 0.85rem; color: #94a3b8; margin: 0; }
.btn-primary { background: #2563eb; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
.btn-secondary { background: #64748b; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
.btn-edit { background: #f59e0b; color: white; border: none; padding: 4px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; }
.btn-delete { background: #ef4444; color: white; border: none; padding: 4px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); display: flex; justify-content: center; align-items: center; }
.modal-card { background: white; padding: 30px; border-radius: 8px; width: 420px; }
.form-group { display: flex; flex-direction: column; margin-bottom: 15px; }
.form-group label { margin-bottom: 5px; font-weight: bold; }
.form-group input, .form-group textarea { padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
.empty-state { text-align: center; color: #64748b; }
</style>