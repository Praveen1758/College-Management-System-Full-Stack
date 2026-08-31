class EnrollmentConfirmationJob < ApplicationJob
  queue_as :default

  # Sidekiq retry behavior built-in
  retry_on StandardError, attempts: 3, wait: 5.seconds

  def perform(student_email, course_name)
    # Simulate sending email asynchronously
    Rails.logger.info "Sending enrollment confirmation email to #{student_email} for course: #{course_name}..."

    # In a real app, you would call ActionMailer here:
    # StudentMailer.enrollment_confirmation(student_email, course_name).deliver_now
  end
end
