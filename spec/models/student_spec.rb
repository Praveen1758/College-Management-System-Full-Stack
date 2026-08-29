require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:course) { Course.create!(name: 'Computer Science') }

  subject do
    described_class.new(
      name: 'John Doe',
      email: 'john@example.com',
      age: 20,
      marks: 85,
      course: course
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid without a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid with negative age' do
    subject.age = -5
    expect(subject).not_to be_valid
  end

  it 'is invalid with marks over 100' do
    subject.marks = 105
    expect(subject).not_to be_valid
  end
end
