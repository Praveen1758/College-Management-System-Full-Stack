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
          <th>Sl No</th>
          <th>Name</th>
          <th>Email</th>
          <th>Age</th>
          <th>Marks</th>
          <th v-if="authStore.isAdmin || authStore.isTeacher">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(student, index) in students" :key="student.id">
          <td>{{ ((currentPage - 1) * itemsPerPage) + index + 1 }}</td>
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

    <div class="pagination-controls" v-if="totalPages > 1">
      <button 
        :disabled="currentPage === 1" 
        @click="changePage(currentPage - 1)"
        class="pagination-btn"
      >
        &laquo; Previous
      </button>

      <span class="page-info">
        Page <strong>{{ currentPage }}</strong> of <strong>{{ totalPages }}</strong>
      </span>

      <button 
        :disabled="currentPage === totalPages" 
        @click="changePage(currentPage + 1)"
        class="pagination-btn"
      >
        Next &raquo;
      </button>
    </div>

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
          <div class="form-group">
            <label>Course</label>
            <select v-model="form.course_id" required>
              <option value="" disabled>-- Select Course --</option>
              <option v-for="course in courses" :key="course.id" :value="course.id">
                {{ course.name }}
              </option>
            </select>
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
const searchQuery = ref('');
const showModal = ref(false);
const isEditing = ref(false);
const courses = ref([]);

const students = ref([]);
const totalPages = ref(1);
const currentPage = ref(1);
const itemsPerPage = ref(20);

const fetchCourses = async () => {
  try {
    const res = await api.get('/courses');
    courses.value = res.data.data ? res.data.data : (Array.isArray(res.data) ? res.data : []);
  } catch (err) {
    console.error(err);
  }
};

const form = ref({
  id: null,
  name: '',
  email: '',
  age: '',
  marks: '',
  course_id: ''
});


const fetchStudents = async (page = 1) => {
  try {
    const res = await api.get('/students', {
      params: { page: page, per_page: itemsPerPage.value }
    });
    
    // Extract students array and metadata returned from Rails
    students.value = res.data.data;
    currentPage.value = res.data.meta.page;
    totalPages.value = Math.ceil(res.data.meta.total / res.data.meta.per_page);
  } catch (err) {
    console.error('Error fetching students:', err);
  }
};

const changePage = (newPage) => {
  if (newPage >= 1 && newPage <= totalPages.value) {
    fetchStudents(newPage);
  }
};

const openModal = (student = null) => {
  if (student) {
    isEditing.value = true;
    form.value = { ...student, course_id: student.course_id || '' };
  } else {
    isEditing.value = false;
    form.value = { id: null, name: '', email: '', age: '', marks: '', course_id: '' };
  }
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
};

const saveStudent = async () => {
  try {
    const payload = {
      name: form.value.name,
      email: form.value.email,
      age: form.value.age,
      marks: form.value.marks,
      course_id: form.value.course_id
    };

    if (isEditing.value) {
      await api.put(`/students/${form.value.id}`, { student: payload });
    } else {
      await api.post('/students', { student: payload });
    }
    closeModal();
    fetchStudents();
  } catch (err) {
    alert(err.response?.data?.errors?.join(', ') || err.response?.data?.error || 'Failed to save student.');
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

onMounted(() => {
  fetchStudents();
  fetchCourses();
});

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
.pagination-controls {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  margin-top: 20px;
  padding: 10px 0;
}

.pagination-btn {
  padding: 8px 16px;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.pagination-btn:hover:not(:disabled) {
  background-color: #2563eb;
}

.pagination-btn:disabled {
  background-color: #cbd5e1;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #475569;
}
</style>