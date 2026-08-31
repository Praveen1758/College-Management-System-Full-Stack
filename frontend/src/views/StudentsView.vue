<template>
  <div class="view-container">
    <div class="header-section">
      <h2>Students Directory</h2>
      <button v-if="authStore.isAdmin" @click="openModal()" class="btn-primary">+ Add Student</button>
    </div>

    <!-- Search Bar -->
    <div class="search-bar">
      <input 
        v-model="searchQuery" 
        @input="fetchStudents" 
        placeholder="Search students by name or email..." 
      />
    </div>

    <!-- Students Table -->
    <table v-if="students.length" class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Age</th>
          <th>Marks</th>
          <th v-if="authStore.isAdmin || authStore.isTeacher">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.id">
          <td>{{ student.id }}</td>
          <td><strong>{{ student.name }}</strong></td>
          <td>{{ student.email }}</td>
          <td>{{ student.age }}</td>
          <td>{{ student.marks }}</td>
          <td v-if="authStore.isAdmin || authStore.isTeacher" class="actions-cell">
            <button @click="openModal(student)" class="btn-edit">Edit</button>
            <button v-if="authStore.isAdmin" @click="deleteStudent(student.id)" class="btn-delete">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else class="empty-state">No students found.</p>

    <!-- Modal Form (Create / Edit) -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <h3>{{ isEditing ? 'Edit Student' : 'Add New Student' }}</h3>
        <form @submit.prevent="saveStudent">
          <div class="form-group">
            <label>Full Name</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>Email</label>
            <input type="email" v-model="form.email" required />
          </div>
          <div class="form-group">
            <label>Age</label>
            <input type="number" v-model="form.age" required />
          </div>
          <div class="form-group">
            <label>Marks</label>
            <input type="number" v-model="form.marks" required />
          </div>
          <div class="modal-actions">
            <button type="button" @click="closeModal" class="btn-secondary">Cancel</button>
            <button type="submit" class="btn-primary">Save</button>
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
const students = ref([]);
const searchQuery = ref('');
const showModal = ref(false);
const isEditing = ref(false);

const form = ref({
  id: null,
  name: '',
  email: '',
  age: '',
  marks: ''
});

const fetchStudents = async () => {
  try {
    const response = await api.get('/students', {
      params: { search: searchQuery.value }
    });
    students.value = Array.isArray(response.data) ? response.data : response.data.data || [];
  } catch (err) {
    console.error('Failed to load students:', err);
  }
};

const openModal = (student = null) => {
  if (student) {
    isEditing.value = true;
    form.value = { ...student };
  } else {
    isEditing.value = false;
    form.value = { id: null, name: '', email: '', age: '', marks: '' };
  }
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
};

const saveStudent = async () => {
  try {
    if (isEditing.value) {
      await api.put(`/students/${form.value.id}`, { student: form.value });
    } else {
      await api.post('/students', { student: form.value });
    }
    closeModal();
    fetchStudents();
  } catch (err) {
    alert(err.response?.data?.error || 'Failed to save student record.');
  }
};

const deleteStudent = async (id) => {
  if (!confirm('Are you sure you want to delete this student?')) return;
  try {
    await api.delete(`/students/${id}`);
    fetchStudents();
  } catch (err) {
    alert(err.response?.data?.error || 'Failed to delete student.');
  }
};

onMounted(fetchStudents);
</script>

<style scoped>
.view-container { max-width: 900px; margin: 30px auto; padding: 20px; background: white; border-radius: 8px; }
.header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.search-bar input { width: 100%; padding: 10px; margin-bottom: 20px; border: 1px solid #cbd5e1; border-radius: 4px; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { border: 1px solid #e2e8f0; padding: 12px; text-align: left; }
.data-table th { background-color: #f8fafc; }
.actions-cell { display: flex; gap: 8px; }
.btn-primary { background: #2563eb; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
.btn-secondary { background: #64748b; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
.btn-edit { background: #f59e0b; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; }
.btn-delete { background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); display: flex; justify-content: center; align-items: center; }
.modal-card { background: white; padding: 30px; border-radius: 8px; width: 400px; }
.form-group { display: flex; flex-direction: column; margin-bottom: 15px; }
.form-group label { margin-bottom: 5px; font-weight: bold; }
.form-group input { padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
.empty-state { text-align: center; color: #64748b; }
</style>