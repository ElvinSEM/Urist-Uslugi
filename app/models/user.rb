class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :service_requests, -> { order(created_at: :desc) }, foreign_key: :client_id,
           inverse_of: :client, dependent: :nullify
  has_many :assigned_service_requests, -> { order(created_at: :desc) },
           class_name: "ServiceRequest", foreign_key: :lawyer_id,
           inverse_of: :lawyer, dependent: :nullify
  has_many :notifications, dependent: :destroy

  enum :role, { admin: 0, lawyer: 1, client: 2 }, default: :client

  scope :with_role, ->(role_name) { role_name.present? ? where(role: role_name) : all }
  scope :lawyers, -> { with_role(:lawyer) }
  scope :clients, -> { with_role(:client) }

  validates :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(" ")
  end
end
