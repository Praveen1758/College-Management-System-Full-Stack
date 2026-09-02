# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# ----------------------
# Demo Users
# ----------------------

admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "password123"
  u.role = "admin"
end

teacher = User.find_or_create_by!(email: "teacher@example.com") do |u|
  u.name = "Teacher User"
  u.password = "password123"
  u.role = "teacher"
end

student_user = User.find_or_create_by!(email: "student@example.com") do |u|
  u.name = "Student User"
  u.password = "password123"
  u.role = "student"
end

# ----------------------
# Demo Courses
# ----------------------

cs = Course.find_or_create_by!(name: "Computer Science") do |c|
  c.description = "Core CS Department"
end

mech = Course.find_or_create_by!(name: "Mechanical") do |c|
  c.description = "Mechanical Engineering Department"
end

ise = Course.find_or_create_by!(name: "Information Science") do |c|
  c.description = "Information Science Department"
end

ai = Course.find_or_create_by!(name: "Artificial Intelligence") do |c|
  c.description = "AI Department"
end

# ----------------------
# Demo Student Profile
# ----------------------

Student.find_or_create_by!(email: "student@example.com") do |s|
  s.name = "Student User"
  s.age = 20
  s.marks = 78
  s.course = cs
end

puts "Demo accounts and sample data created successfully."