<template>
  <div class="container">
    <h1>Student Enrollment</h1>

    <div class="card">
      <div class="form-group">
        <label>Student</label>
        <select v-model="selectedStudent">
          <option value="">Select Student</option>
          <option
            v-for="student in students"
            :key="student.id"
            :value="student.id"
          >
            {{ student.name }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>Course</label>
        <select v-model="selectedCourse">
          <option value="">Select Course</option>
          <option
            v-for="course in courses"
            :key="course.id"
            :value="course.id"
          >
            {{ course.name }}
          </option>
        </select>
      </div>

      <button @click="enrollStudent" :disabled="loading">
        {{ loading ? "Enrolling..." : "Enroll Student" }}
      </button>

      <p v-if="message" class="success">{{ message }}</p>
      <p v-if="error" class="error">{{ error }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/services/api";

const students = ref([]);
const courses = ref([]);

const selectedStudent = ref("");
const selectedCourse = ref("");

const loading = ref(false);
const message = ref("");
const error = ref("");

const loadData = async () => {
  try {
    const studentsRes = await api.get("/students?per_page=100");
    const coursesRes = await api.get("/courses?per_page=100");

    students.value = studentsRes.data.data;
    courses.value = coursesRes.data.data;
  } catch (err) {
    error.value = "Failed to load students or courses.";
    console.error(err);
  }
};

const enrollStudent = async () => {
  message.value = "";
  error.value = "";

  if (!selectedStudent.value || !selectedCourse.value) {
    error.value = "Please select both student and course.";
    return;
  }

  loading.value = true;

  try {
    await api.post("/enrollments", {
      student_id: selectedStudent.value,
      course_id: selectedCourse.value,
    });

    message.value = "Student enrolled successfully.";

    selectedStudent.value = "";
    selectedCourse.value = "";
  } catch (err) {
    error.value =
      err.response?.data?.error ||
      "Enrollment failed.";
  } finally {
    loading.value = false;
  }
};

onMounted(loadData);
</script>

<style scoped>
.container{
  max-width:700px;
  margin:auto;
  padding:20px;
}

.card{
  background:white;
  padding:25px;
  border-radius:10px;
  box-shadow:0 2px 8px rgba(0,0,0,.1);
}

.form-group{
  margin-bottom:20px;
}

label{
  display:block;
  margin-bottom:8px;
  font-weight:bold;
}

select{
  width:100%;
  padding:10px;
  border-radius:6px;
  border:1px solid #ccc;
}

button{
  width:100%;
  padding:12px;
  background:#2563eb;
  color:white;
  border:none;
  border-radius:6px;
  cursor:pointer;
}

button:hover{
  background:#1d4ed8;
}

button:disabled{
  background:#94a3b8;
}

.success{
  color:green;
  margin-top:15px;
}

.error{
  color:red;
  margin-top:15px;
}
</style>