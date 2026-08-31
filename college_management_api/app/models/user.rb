class User < ApplicationRecord
  has_secure_password

  ROLES = %w[admin teacher student].freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }
end
