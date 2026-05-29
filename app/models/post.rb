class Post < ApplicationRecord
  scope :published, -> { where(published: true) }
  scope :recent_first, -> { order(created_at: :desc) }

  validates :title, :content, presence: true

  def image_name
    "#{title.parameterize}.svg"
  end

  def image_path
    "blog/#{image_name}"
  end
end
