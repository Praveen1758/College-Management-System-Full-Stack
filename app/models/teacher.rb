class Teacher < ApplicationRecord
  has_many :courses

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end