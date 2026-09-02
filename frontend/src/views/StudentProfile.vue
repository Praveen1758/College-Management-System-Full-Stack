<template>
  <div class="profile-container">
    <div class="profile-card" v-if="student">
      <h1>My Profile</h1>

      <div class="info">
        <p><strong>Name:</strong> {{ student.name }}</p>
        <p><strong>Email:</strong> {{ student.email }}</p>
        <p><strong>Age:</strong> {{ student.age }}</p>
        <p><strong>Marks:</strong> {{ student.marks }}</p>
        <p><strong>Course:</strong> {{ student.course?.name }}</p>
      </div>
      
      <button @click="editing = !editing">
        {{ editing ? "Cancel" : "Edit Profile" }}
      </button>

      <div v-if="editing">
      <input v-model="form.name" />
      <input v-model="form.age" type="number" />
      <button @click="saveProfile">Save</button>
      </div>
      
      
    </div>
    <div v-else>
      Loading profile...
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/services/api";

const student = ref(null);
const editing = ref(false);

const form = ref({
  name: "",
  age: "",
});

const saveProfile = async () => {
  try {
    const response = await api.patch("/students/me", {
      student: form.value,
    });

    student.value = response.data;
    editing.value = false;
    alert("Profile updated!");
  } catch (err) {
    console.error(err);
    alert("Update failed.");
  }
};

const loadProfile = async () => {
  try {
    const response = await api.get("/students/me");
    student.value = response.data;

    form.value.name = response.data.name;
    form.value.age = response.data.age;
  } catch (error) {
    console.log(error.response);
    alert(error.response?.data?.error || JSON.stringify(error.response?.data) || error.message);
  }
};

onMounted(loadProfile);
</script>

<style scoped>
.profile-container {
  display:flex;
  justify-content:center;
  padding:40px;
}

.profile-card{
  background:white;
  padding:30px;
  border-radius:10px;
  width:500px;
  box-shadow:0 2px 10px rgba(0,0,0,.1);
}

.info p{
  margin:12px 0;
}

.edit-btn{
  margin-top:20px;
  background:#2563eb;
  color:white;
  border:none;
  padding:10px 18px;
  border-radius:6px;
  cursor:pointer;
}
</style>