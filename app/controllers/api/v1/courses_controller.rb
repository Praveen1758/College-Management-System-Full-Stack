module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: [ :show, :update, :destroy ]

      # GET /api/v1/courses
      def index
        @courses = Course.page(params[:page]).per(params[:per_page] || 20)
        render json: {
          data: @courses,
          meta: {
            page: @courses.current_page,
            per_page: @courses.limit_value,
            total: @courses.total_count
          }
        }
      end

      # GET /api/v1/courses/:id
      def show
        render json: @course
      end

      # POST /api/v1/courses
      def create
        @course = Course.new(course_params)
        if @course.save
          render json: @course, status: :created
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/courses/:id
      def update
        if @course.update(course_params)
          render json: @course
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/courses/:id
      def destroy
        @course.destroy
        head :no_content
      end

      private

      def set_course
        @course = Course.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Course not found" }, status: :not_found
      end

      def course_params
        params.require(:course).permit(:name, :description)
      end
    end
  end
end
