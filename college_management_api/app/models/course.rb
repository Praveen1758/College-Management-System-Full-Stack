class Course < ApplicationRecord
  has_many :students, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  validates :name, presence: true
end
