# == Schema Information
#
# Table name: microposts
#
#  id         :bigint           not null, primary key
#  content    :text
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Micropost < ApplicationRecord
  belongs_to       :user , counter_cache: true
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, presence: false,    content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size: { less_than: 5.megabytes,
                            message:     "should be less than 5MB" }

   #Returns a resized image for display.
  def display_image
  image.variable? ? image.variant(resize_to_limit: [500, 500]) : image
end
end
