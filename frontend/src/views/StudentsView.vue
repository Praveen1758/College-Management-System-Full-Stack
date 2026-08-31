<template>
  <div class="students-container">
    <h2>Students List</h2>
    <button @click="fetchStudents">Refresh Data</button>

    <table v-if="students.length" border="1">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Age</th>
          <th>Marks</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.id">
          <td>{{ student.id }}</td>
          <td>{{ student.name }}</td>
          <td>{{ student.email }}</td>
          <td>{{ student.age }}</td>
          <td>{{ student.marks }}</td>
        </tr>
      </tbody>
    </table>
    <p v-else>No students found or loading...</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '@/services/api';

const students = ref([]);

const fetchStudents = async () => {
  try {
    const response = await api.get('/students');
    students.value = response.data.data;
  } catch (err) {
    console.error('Failed to fetch students:', err);
  }
};

onMounted(fetchStudents);
</script>