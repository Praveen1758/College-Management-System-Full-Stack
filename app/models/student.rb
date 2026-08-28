class Student < ApplicationRecord
  belongs_to :course
  has_many :enrollments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age, numericality: { greater_than: 0 }
  validates :marks, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
