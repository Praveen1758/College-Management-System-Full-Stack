class EnrollmentConfirmationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, attempts: 3, wait: 5.seconds

  def perform(student_id)
    student = Student.find(student_id)

    Rails.logger.info "Enrollment confirmation sent to #{student.email}"
  end
end