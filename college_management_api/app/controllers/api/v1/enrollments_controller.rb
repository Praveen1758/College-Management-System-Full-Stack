module Api
  module V1
    class EnrollmentsController < ApplicationController
      before_action :authenticate_request!
      before_action -> { authorize_roles!(:admin) }

      # POST /api/v1/enrollments
      def create
        result = Enrollments::Create.call(
          student_id: enrollment_params[:student_id],
          course_id: enrollment_params[:course_id]
        )

        if result[:success]
          EnrollmentConfirmationJob.perform_later(result[:enrollment].student.id)


          render json: result[:enrollment], status: result[:status]
        else
          render json: { error: result[:error] }, status: result[:status]
        end
      end

      def destroy
        enrollment = Enrollment.find_by(
          student_id: enrollment_params[:student_id],
          course_id: enrollment_params[:course_id]
        )

        if enrollment
          student = enrollment.student
          enrollment.destroy
          
          # Crucial: Reset student's course_id so Course.includes(:students) stops returning them
          student.update(course_id: nil) if student && student.course_id.to_s == enrollment_params[:course_id].to_s
          
          render json: { message: 'Student removed from course successfully' }, status: :ok
        else
          render json: { error: 'Enrollment record not found' }, status: :not_found
        end
      end

      private

      def enrollment_params
        params.require(:enrollment).permit(:student_id, :course_id)
      end
    end
  end
end
