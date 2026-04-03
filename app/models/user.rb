class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :service_requests, dependent: :nullify
  has_many :notifications, dependent: :destroy

  enum :role, { admin: 0, lawyer: 1, client: 2 }, default: :client

  validates :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(" ")
  end
end
