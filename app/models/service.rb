class Service < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  audited

  belongs_to :category
  has_many :service_requests, dependent: :restrict_with_exception

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :priced_from, ->(value) { where("price_cents >= ?", value.to_i * 100) if value.present? }
  scope :priced_to, ->(value) { where("price_cents <= ?", value.to_i * 100) if value.present? }

  validates :title, :description, :price_cents, :slug, presence: true
  validates :title, :slug, uniqueness: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, to: :category, prefix: true

  def price
    price_cents / 100.0
  end

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def to_param
    slug
  end
end
