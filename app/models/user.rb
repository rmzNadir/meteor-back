class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_many :sales, dependent: :nullify
  has_one_attached :image
  has_secure_password # Makes the model encrypt the user's password
  after_create :create_cart

  validates :email, presence: true
  validates :email, uniqueness: true
  enum role: { user: 0, admin: 1, client_user: 2 }

  def admin?
    role == "admin"
  end

  def client_user?
    role == "client_user"
  end

  private

  def create_cart
    Cart.create(user_id: id)
  end
end
