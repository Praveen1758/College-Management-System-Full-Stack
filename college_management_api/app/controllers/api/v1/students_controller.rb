module Api
  module V1
    class StudentsController < ApplicationController
      before_action :authenticate_request!
      before_action -> { authorize_roles!(:admin, :teacher) }, only: [ :index, :statistics ]
      before_action -> { authorize_roles!(:admin) }, only: [ :create, :destroy ]
      before_action -> { authorize_roles!(:admin, :teacher) }, only: [ :update ]
      before_action :set_student, only: [ :show, :update, :destroy ]

      # GET /api/v1/students
      def index
        # Eager load course to prevent N+1 queries
        students = Student.includes(:course)

        if params[:search].present?
          query = "%#{params[:search].downcase}%"
          students = students.where("LOWER(students.name) LIKE ? OR LOWER(students.email) LIKE ?", query, query)
        end

        students = students.where(course_id: params[:course_id]) if params[:course_id].present?
        students = students.where("marks >= ?", params[:min_marks]) if params[:min_marks].present?

        # Explicitly order by student ID before paginating to fix scrambled order
        paginated_students = students.order(:id).page(params[:page]).per(params[:per_page] || 20)

        render json: {
          data: paginated_students.as_json(include: :course),
          meta: {
            page: paginated_students.current_page,
            per_page: paginated_students.limit_value,
            total: paginated_students.total_count
          }
        }
      end

      # GET /api/v1/students/:id
      def show
        render json: @student
      end

      # POST /api/v1/students
      def create
        @student = Student.new(student_params)
        if @student.save
          render json: @student, status: :created
        else
          render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/students/:id
      def update
        if @student.update(student_params)
          render json: @student
        else
          render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/students/:id
      def destroy
        @student.destroy
        head :no_content
      end

      # GET /api/v1/students/statistics
      # Performed efficiently at the SQL level
      def statistics
        stats = Student.pluck(
          Arel.sql("COUNT(*)"),
          Arel.sql("AVG(marks)"),
          Arel.sql("MAX(marks)"),
          Arel.sql("MIN(marks)"),
          Arel.sql("COUNT(CASE WHEN marks >= 40 THEN 1 END)"),
          Arel.sql("COUNT(CASE WHEN marks < 40 THEN 1 END)")
        ).first

        render json: {
          total_students: stats[0].to_i,
          average_marks: stats[1] ? stats[1].to_f.round(2) : 0,
          highest_marks: stats[2].to_i,
          lowest_marks: stats[3].to_i,
          passed_students: stats[4].to_i,
          failed_students: stats[5].to_i
        }
      end

      def me
        student = Student.find_by(email: current_user.email)

        if student
          render json: student.as_json(include: :course)
        else
          render json: { error: "Student profile not found" }, status: :not_found
        end
      end

      private

      def set_student
        @student = Student.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Student not found" }, status: :not_found
      end

      def student_params
        params.require(:student).permit(:name, :email, :age, :marks, :course_id)
      end
    end
  end
end
