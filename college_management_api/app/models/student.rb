class Student < ApplicationRecord
  belongs_to :course, optional: true 
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid format" }
  validates :age, numericality: { greater_than: 0 }
  validates :marks, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
