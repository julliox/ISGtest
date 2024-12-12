class User < ApplicationRecord
  has_secure_password

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # Associações
  has_many :posts, dependent: :destroy
end
