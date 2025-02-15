# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :followings_count
  belongs_to :followed, class_name: "User", counter_cache: :followers_count
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end

