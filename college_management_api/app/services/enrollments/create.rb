module Enrollments
  class Create
    def self.call(student_id:, course_id:)
      enrollment = Enrollment.new(student_id: student_id, course_id: course_id)

      if enrollment.save
        # Sync the direct belongs_to relation so Course.includes(:students) displays the student!
        student = Student.find_by(id: student_id)
        student&.update(course_id: course_id)

        { success: true, enrollment: enrollment, status: :created }
      else
        { success: false, error: enrollment.errors.full_messages.join(', '), status: :unprocessable_entity }
      end
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

      if Enrollment.exists?(student_id: student.id, course_id: course.id)
        return { success: false, error: "Student is already enrolled in this course", status: :unprocessable_entity }
      end

      enrollment = nil
      ActiveRecord::Base.transaction do
        enrollment = Enrollment.create!(
          student: student,
          course: course,
          enrolled_at: Time.current,
          status: "active"
        )
      end

      # Queue background job after successful enrollment transaction
      EnrollmentConfirmationJob.perform_later(student.email, course.name)

      { success: true, enrollment: enrollment, status: :created }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, error: e.message, status: :unprocessable_entity }
    rescue StandardError => e
      { success: false, error: e.message, status: :internal_server_error }
    end
  end
end
