require 'rails_helper'

RSpec.describe Enrollments::Create do
  let(:course) { Course.create!(name: 'Data Structures') }
  let(:student) { Student.create!(name: 'Alice', email: 'alice@example.com', age: 21, marks: 90, course: course) }

  it 'successfully enrolls a student' do
    result = described_class.call(student_id: student.id, course_id: course.id)
    expect(result[:success]).to be true
    expect(result[:enrollment]).to be_persisted
  end

  it 'prevents duplicate enrollment' do
    described_class.call(student_id: student.id, course_id: course.id)
    result = described_class.call(student_id: student.id, course_id: course.id)

    expect(result[:success]).to be false
    expect(result[:error]).to eq('Student is already enrolled in this course')
  end
end
