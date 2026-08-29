# College Management System API

A **Ruby on Rails 7 API** application backed by **PostgreSQL**, **Redis**, and **Sidekiq** for managing **students, courses, teachers, and enrollments**. The application uses **JWT authentication**, **Role-Based Access Control (RBAC)**, and asynchronous background jobs for a scalable API architecture.

---

## Features

* JWT-based Authentication
* Role-Based Access Control (Admin, Teacher, Student)
* Student, Course, Teacher & Enrollment Management
* Search, Filtering & Pagination
* SQL-based Student Statistics
* Background Job Processing with Sidekiq
* Redis-powered Job Queue
* PostgreSQL Database
* Service Objects for Business Logic
* Database Transactions for Data Integrity

---

# Setup Instructions

Follow these steps to run the project locally.

## 1. Install Dependencies

```bash
bundle install
```

## 2. Setup PostgreSQL Database

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## 3. Start the Rails Server

```bash
bin/rails server
```

The API will now be available on:

```text
http://localhost:3000
```

---

# Redis & Sidekiq Setup

Background jobs require both **Redis** and **Sidekiq**.

## Step 1: Verify Redis

```bash
redis-cli ping
```

Expected output:

```text
PONG
```

If Redis is not running, start it manually.

```bash
redis-server
```

## Step 2: Start Sidekiq

Open a new terminal and run:

```bash
bundle exec sidekiq
```

Sidekiq will now process asynchronous jobs such as enrollment confirmation emails.

---

# API Documentation

All protected endpoints require a JWT token.

### Authorization Header

```http
Authorization: Bearer <JWT_TOKEN>
```

---

## Authentication

| Method | Endpoint                | Description                 |
| ------ | ----------------------- | --------------------------- |
| POST   | `/api/v1/auth/register` | Register a new user         |
| POST   | `/api/v1/auth/login`    | Login and receive JWT token |

### Register Request

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

---

## Courses

| Method    | Endpoint              | Access |
| --------- | --------------------- | ------ |
| GET       | `/api/v1/courses`     | Public |
| POST      | `/api/v1/courses`     | Admin  |
| GET       | `/api/v1/courses/:id` | Public |
| PATCH/PUT | `/api/v1/courses/:id` | Admin  |
| DELETE    | `/api/v1/courses/:id` | Admin  |

---

## Students

| Method    | Endpoint                      | Access           |
| --------- | ----------------------------- | ---------------- |
| GET       | `/api/v1/students`            | Admin, Teacher   |
| GET       | `/api/v1/students/statistics` | Admin, Teacher   |
| POST      | `/api/v1/students`            | Admin            |
| GET       | `/api/v1/students/:id`        | Authorized Users |
| PATCH/PUT | `/api/v1/students/:id`        | Admin, Teacher   |
| DELETE    | `/api/v1/students/:id`        | Admin            |

### Student List Query Parameters

| Parameter   | Purpose                 |
| ----------- | ----------------------- |
| `search`    | Search students         |
| `course_id` | Filter by course        |
| `min_marks` | Filter by minimum marks |
| `page`      | Pagination              |
| `per_page`  | Records per page        |

Example:

```http
GET /api/v1/students?search=John&course_id=2&min_marks=75&page=1&per_page=10
```

---

## Student Statistics

```http
GET /api/v1/students/statistics
```

Returns aggregated SQL-based statistics such as:

* Total Students
* Average Marks
* Top Performers

---

## Enrollments

| Method | Endpoint              | Access |
| ------ | --------------------- | ------ |
| POST   | `/api/v1/enrollments` | Admin  |

Creates a new enrollment and automatically queues an asynchronous confirmation email using Sidekiq.

---

# Architecture Overview

```text
           Client
              │
              ▼
        Rails API (Controllers)
              │
              ▼
      Service Objects / Models
              │
     ┌────────┴────────┐
     ▼                 ▼
PostgreSQL        Redis + Sidekiq
     │                 │
     └────────┬────────┘
              ▼
      Background Jobs
```

---

# Project Structure

## Models

* User
* Student
* Teacher
* Course
* Enrollment

## Associations

* Student belongs to Course
* Course has many Students
* Student has many Enrollments
* Course has many Enrollments
* Student has many Courses through Enrollments

---

# Key Components

### Authentication

* JWT Tokens
* bcrypt password hashing
* Stateless authentication

### Authorization

Role-Based Access Control with three roles:

* Admin
* Teacher
* Student

### Service Objects

`Enrollments::Create`

Responsibilities:

* Create enrollments
* Prevent duplicate enrollments
* Handle business rules
* Execute database transactions

### Background Jobs

`EnrollmentConfirmationJob`

Processes enrollment confirmation emails asynchronously using Sidekiq.

---

# Key Design Decisions

## 1. JWT Authentication

The application uses **JSON Web Tokens (JWT)** instead of server-side sessions.

### Why?

* Stateless authentication
* Easy API integration
* Better scalability
* Reduced server-side session management

---

## 2. Service Objects

Business logic is extracted into dedicated service objects.

Example:

```text
Enrollments::Create
```

Benefits:

* Thin controllers
* Cleaner code
* Easier testing
* Better maintainability

---

## 3. Database Transactions

Critical write operations use:

```ruby
ActiveRecord::Base.transaction
```

This guarantees **atomic execution**, ensuring either all database operations succeed or none are committed.

---

## 4. Background Processing

Time-consuming tasks like email confirmations are handled asynchronously.

**Technology Stack**

* Redis
* Sidekiq

Benefits:

* Faster API responses
* Non-blocking requests
* Reliable job retries

---

## 5. N+1 Query Prevention

Student listing endpoints use eager loading.

```ruby
.includes(:course)
```

This avoids unnecessary database queries and improves performance when loading associated records.

---

# Technology Stack

| Technology      | Purpose               |
| --------------- | --------------------- |
| Ruby on Rails 7 | Backend API           |
| PostgreSQL      | Database              |
| Redis           | Job Queue             |
| Sidekiq         | Background Processing |
| JWT             | Authentication        |
| bcrypt          | Password Hashing      |
| ActiveRecord    | ORM                   |

---

# Running the Complete Application

Open three terminals.

### Terminal 1

```bash
bin/rails server
```

### Terminal 2

```bash
redis-server
```

### Terminal 3

```bash
bundle exec sidekiq
```

Verify Redis:

```bash
redis-cli ping
```

Expected:

```text
PONG
```

Once all three services are running, the College Management System API is fully operational with authentication, CRUD operations, enrollment processing, and asynchronous background job support.
