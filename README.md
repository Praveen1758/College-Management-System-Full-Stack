# College Management System – Full Stack

A full-stack **College Management System** built with **Ruby on Rails 8** and **Vue 3** that provides secure JWT authentication, role-based access control, student and course management, enrollment management, and profile editing.

This project demonstrates REST API development, authentication, authorization, database transactions, and frontend integration using a modern full-stack architecture.

## Features

### Authentication

* JWT-based authentication
* Secure login for **Admin**, **Teacher**, and **Student**
* Automatic role-based routing after login

### Admin

* Manage students (Create, Read, Update, Delete)
* Manage courses
* Enroll students into courses
* View student statistics
* Full administrative access

### Teacher

* View all students
* Edit **marks only**
* View courses
* Restricted from administrative actions

### Student

* Login using personal account
* View own profile
* Edit personal details (Name & Age)
* View enrolled course

### API Features

* RESTful Rails API
* JWT Authorization
* Role-based authorization
* Pagination
* Search students
* Filter by course
* Student statistics endpoint
* Transaction-based enrollment handling

## Tech Stack

| Layer            | Technology      |
| ---------------- | --------------- |
| Backend          | Ruby on Rails 8 |
| Frontend         | Vue 3           |
| State Management | Pinia           |
| HTTP Client      | Axios           |
| Database         | SQLite          |
| Authentication   | JWT             |
| Styling          | CSS             |
| Development      | Vite            |

## Project Structure

```text
College-Mgmt/
├── college_management_api/
│   ├── app/
│   ├── config/
│   ├── db/
│   └── ...
└── frontend/
    ├── src/
    ├── components/
    ├── views/
    └── ...
```

## Installation

### Clone Repository

```bash
git clone https://github.com/Praveen1758/College-Management-System-Full-Stack.git
cd College-Management-System-Full-Stack
```

### Backend Setup

```bash
cd college_management_api

bundle install
rails db:migrate
rails db:seed
rails server
```

Backend runs on:

```text
http://localhost:3000
```

### Frontend Setup

Open another terminal.

```bash
cd frontend

npm install
npm run dev
```

Frontend runs on:

```text
http://localhost:5173
```

## Demo Accounts

After running `rails db:seed`, use these accounts.

| Role    | Email                 | Password      |
| ------- | --------------------- | ------------- |
| Admin   | `admin@example.com`   | `Admin@123`   |
| Teacher | `teacher@example.com` | `Teacher@123` |
| Student | `student@example.com` | `Student@123` |

Students created by the Admin automatically receive:

* Email: Student's registered email
* Password: `Student@123`

## API Endpoints

### Authentication

| Method | Endpoint                |
| ------ | ----------------------- |
| POST   | `/api/v1/auth/login`    |
| POST   | `/api/v1/auth/register` |

### Students

| Method | Endpoint                      |
| ------ | ----------------------------- |
| GET    | `/api/v1/students`            |
| GET    | `/api/v1/students/me`         |
| PATCH  | `/api/v1/students/me`         |
| POST   | `/api/v1/students`            |
| PATCH  | `/api/v1/students/:id`        |
| DELETE | `/api/v1/students/:id`        |
| GET    | `/api/v1/students/statistics` |

### Courses

| Method | Endpoint              |
| ------ | --------------------- |
| GET    | `/api/v1/courses`     |
| POST   | `/api/v1/courses`     |
| PATCH  | `/api/v1/courses/:id` |
| DELETE | `/api/v1/courses/:id` |

### Enrollments

| Method | Endpoint                      |
| ------ | ----------------------------- |
| POST   | `/api/v1/enrollments`         |
| DELETE | `/api/v1/enrollments/destroy` |

## Role Permissions

| Feature          | Admin |   Teacher  |   Student   |
| ---------------- | :---: | :--------: | :---------: |
| View Students    |   ✅   |      ✅     |      ❌      |
| Create Student   |   ✅   |      ❌     |      ❌      |
| Edit Student     |   ✅   | Marks Only | Own Profile |
| Delete Student   |   ✅   |      ❌     |      ❌      |
| Manage Courses   |   ✅   |    View    |     View    |
| Enroll Students  |   ✅   |      ❌     |      ❌      |
| View Own Profile |   ❌   |      ❌     |      ✅      |

## Screenshots

### Admin Dashboard

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-36-52" src="https://github.com/user-attachments/assets/be56703b-d14b-47d5-a645-702b9e6d6bc3" /><img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-36-44" src="https://github.com/user-attachments/assets/cad42794-1997-464d-b686-feb3b59a0b16" />


### Student Profile

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-35-56" src="https://github.com/user-attachments/assets/2ddef03b-dc80-4b21-8b7e-197a9ffdaaa0" />

### Enrollment Page

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-37-01" src="https://github.com/user-attachments/assets/46a1a77b-dde9-455e-b545-81d76eaa5acb" /><img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-35-56" src="https://github.com/user-attachments/assets/4508584e-07db-4c27-adf5-ed4d06eafcda" />


## Learning Highlights

During development, this project involved implementing:

* JWT authentication
* Role-based authorization
* Vue Router navigation guards
* Pinia state management
* RESTful Rails APIs
* Database transactions
* Pagination and filtering
* CORS configuration
* Frontend-backend integration using Axios
* Git workflow with meaningful commits

## Future Improvements

* Dashboard analytics with charts
* Attendance management
* Teacher-specific dashboard
* Password reset functionality
* Email notifications
* Profile picture uploads
* Responsive mobile UI
* Docker deployment
* PostgreSQL production setup

## Author

**Praveen K**

* GitHub: https://github.com/Praveen1758
* Give it a Star If you like My Project
