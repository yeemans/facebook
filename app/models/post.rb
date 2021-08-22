class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likings, foreign_key: :liked_post_id 
  has_many :liking_users, through: :likings, source: :liking_user
end
  