class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :friendships, dependent: :destroy  
  has_many :friends, through: :friendships
  has_many :posts
  has_many :comments
  has_many :friend_requests, foreign_key: 'friend_1_id'
  has_many :likings, foreign_key: :liking_user_id
  has_many :liked_posts, through: :likings, class_name: "Post"

  validates :username, uniqueness: true
end
