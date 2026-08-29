module Enrollments
  class Create
    def self.call(student_id:, course_id:)
      new(student_id: student_id, course_id: course_id).call
    end

    def initialize(student_id:, course_id:)
      @student_id = student_id
      @course_id = course_id
    end

    def call
      student = Student.find_by(id: @student_id)
      return { success: false, error: "Student not found", status: :not_found } unless student

      course = Course.find_by(id: @course_id)
      return { success: false, error: "Course not found", status: :not_found } unless course

      # Prevent duplicate enrollment
      if Enrollment.exists?(student_id: student.id, course_id: course.id)
        return { success: false, error: "Student is already enrolled in this course", status: :unprocessable_entity }
      end

      # Database Transaction ensures atomicity
      enrollment = nil
      ActiveRecord::Base.transaction do
        enrollment = Enrollment.create!(
          student: student,
          course: course,
          enrolled_at: Time.current,
          status: "active"
        )
      end

      { success: true, enrollment: enrollment, status: :created }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, error: e.message, status: :unprocessable_entity }
    rescue StandardError => e
      { success: false, error: e.message, status: :internal_server_error }
    end
  end
end
