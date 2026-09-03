# College Management System – Full Stack

A production-ready **College Management System** built with **Ruby on Rails 8** and **Vue 3** featuring JWT authentication, role-based access control, student and course management, enrollment workflows, Redis caching, Sidekiq background jobs, Swagger API documentation, Docker containerization, and CI integration.

This project demonstrates modern full-stack development using a RESTful Rails API with a Vue frontend and production-oriented backend practices.

---

## Features

### Authentication

* JWT-based authentication
* Secure login for **Admin**, **Teacher**, and **Student**
* Protected routes using Vue Router navigation guards
* Automatic role-based redirection after login

### Admin

* Create, View, Update and Delete students
* Manage courses
* Enroll students into courses
* View student statistics
* Full administrative access

### Teacher

* View all students
* Update **marks only**
* View courses
* Restricted from administrative actions

### Student

* Login using personal account
* View personal profile
* Edit own **Name** and **Age**
* View enrolled course

---

## Advanced Backend Features

* Redis caching for optimized API responses
* Sidekiq background job processing
* Automatic enrollment handling
* Automatic User account creation when an Admin creates a student
* Swagger (OpenAPI) API documentation
* Rack::Attack login rate limiting
* Docker & Docker Compose support
* GitHub Actions CI pipeline

---

## Tech Stack

| Layer            | Technology          |
| ---------------- | ------------------- |
| Backend          | Ruby on Rails 8     |
| Frontend         | Vue 3               |
| State Management | Pinia               |
| HTTP Client      | Axios               |
| Database         | PostgreSQL (Docker) |
| Authentication   | JWT                 |
| Cache            | Redis               |
| Background Jobs  | Sidekiq             |
| API Docs         | Swagger (Rswag)     |
| Rate Limiting    | Rack::Attack        |
| Containerization | Docker              |
| Development      | Vite                |

---

## Project Structure

```text
College-Mgmt/
├── college_management_api/
│   ├── app/
│   ├── config/
│   ├── db/
│   ├── spec/
│   └── Dockerfile
├── frontend/
│   ├── src/
│   ├── views/
│   ├── components/
│   └── ...
└── docker-compose.yml
```

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/Praveen1758/College-Management-System-Full-Stack.git
cd College-Management-System-Full-Stack
```

---

## Option 1: Run with Docker (Recommended)

Start the complete application with a single command.

```bash
docker compose up --build
```

### Services

| Service      | URL                            |
| ------------ | ------------------------------ |
| Frontend     | http://localhost:5173          |
| Backend API  | http://localhost:3000          |
| Swagger Docs | http://localhost:3000/api-docs |

This starts:

* Vue Frontend
* Rails API
* PostgreSQL
* Redis
* Sidekiq Worker

---

## Option 2: Run Locally

### Backend

```bash
cd college_management_api

bundle install
rails db:migrate
rails db:seed
rails server
```

Backend runs at:

```text
http://localhost:3000
```

### Frontend

Open another terminal.

```bash
cd frontend

npm install
npm run dev
```

Frontend runs at:

```text
http://localhost:5173
```

### Optional Services

Redis:

```bash
redis-server
```

Sidekiq:

```bash
bundle exec sidekiq
```

---

## Demo Accounts

After running `rails db:seed`, use these credentials.

| Role    | Email                 | Password      |
| ------- | --------------------- | ------------- |
| Admin   | `admin@example.com`   | `Admin@123`   |
| Teacher | `teacher@example.com` | `Teacher@123` |
| Student | `student@example.com` | `Student@123` |

### Newly Created Students

When an Admin creates a new student:

* **Email:** Student's registered email
* **Password:** `Student@123`

The system automatically creates both:

* Student record
* User login account

---

## API Documentation

Interactive Swagger documentation is available at:

```text
http://localhost:3000/api-docs
```

Swagger allows developers to:

* Explore available endpoints
* Test APIs directly
* View request bodies
* View responses

---

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

---

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

---

## Screenshots

### Admin Dashboard

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-36-52" src="https://github.com/user-attachments/assets/307785b3-d935-491b-b3b4-699dc0f1e44c" /><img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-36-44" src="https://github.com/user-attachments/assets/1ee423ec-9358-4109-90b2-d6ad5fea3fbb" />


### Student Profile

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-35-56" src="https://github.com/user-attachments/assets/ebd17724-ba98-4bb7-aa85-8aec42aa2c77" />
### Enrollment Management

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-35-42" src="https://github.com/user-attachments/assets/ff7cc06a-6e5b-4f45-a619-56d68be44730" /><img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-35-15" src="https://github.com/user-attachments/assets/27175ad3-d800-4a56-bb4f-ad788a709209" />

---

## Project Architecture

<img width="1919" height="1015" alt="Screenshot from 2026-09-02 11-36-28" src="https://github.com/user-attachments/assets/d9ec1884-4910-460f-92cf-c12262c7eb3a" />
The application follows a modern client-server architecture.

* **Vue 3** provides the user interface.
* **Axios** communicates with the Rails REST API.
* **Rails** handles authentication, authorization, business logic, and database operations.
* **PostgreSQL** stores application data.
* **Redis** caches frequently accessed data and acts as Sidekiq's job queue.
* **Sidekiq** processes background jobs asynchronously.

---

## Learning Highlights

During development, this project involved implementing:

* JWT Authentication
* Role-Based Authorization
* Vue Router Navigation Guards
* Pinia State Management
* RESTful Rails APIs
* Service Objects
* Database Transactions
* Pagination
* Search & Filtering
* Redis Caching
* Sidekiq Background Jobs
* Swagger API Documentation
* Rack::Attack Rate Limiting
* Docker Containerization
* GitHub Actions CI
* CORS Configuration
* Frontend–Backend Integration using Axios

---

## Future Improvements

* Dashboard analytics with charts
* Attendance management
* Teacher-specific dashboard
* Password reset functionality
* Email notifications
* Profile picture uploads
* Responsive mobile UI
* Deployment to Render/Railway
* Automated API testing

---

## Author

**Praveen K**

* GitHub: https://github.com/Praveen1758

If you found this project useful, consider giving it a ⭐ on GitHub.
