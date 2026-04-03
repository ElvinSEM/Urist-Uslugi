class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :services, dependent: :destroy

  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_name?
  end

  def to_param
    slug
  end
end
