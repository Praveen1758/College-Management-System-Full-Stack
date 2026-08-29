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
          render json: result[:enrollment], status: result[:status]
        else
          render json: { error: result[:error] }, status: result[:status]
        end
      end

      private

      def enrollment_params
        params.require(:enrollment).permit(:student_id, :course_id)
      end
    end
  end
end
