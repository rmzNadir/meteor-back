class User < ApplicationRecord
  has_secure_password # Makes the model encrypt the user's password

  validates :email, presence: true
  validates :email, uniqueness: true
  enum role: { user: 0, admin: 1 }
end
