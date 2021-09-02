class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :friendships, dependent: :destroy  
  has_many :friends, -> { distinct }, through: :friendships
  has_many :posts
  has_many :comments
  has_many :friend_requests, foreign_key: 'friend_1_id'
  has_many :likings, foreign_key: :liking_user_id
  has_many :liked_posts, through: :likings, class_name: "Post"

  validates :username, uniqueness: true

  after_create :send_registration_email 
  def send_registration_email 
    RegistrationMailer.with(user: self).registration_email.deliver_now
  end
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
     unless user
         user = User.create(username: data['name'],
            email: data['email'],
            password: Devise.friendly_token[0,20], 
            profile_picture: data['image']
         )
     end
    user
  end
  def self.get_duplicates(*columns)
    self.order('created_at ASC').select("#{columns.join(',')}, COUNT(*)").group(columns).having("COUNT(*) > 1")
  end

  def self.dedupe(*columns)
    # find all models and group them on keys which should be common
    self.group_by{|x| columns.map{|col| x.send(col)}}.each do |duplicates|
      first_one = duplicates.shift # or pop to keep last one instead

      # if there are any more left, they are duplicates then delete all of them
      duplicates.each{|x| x.destroy}
    end
  end
end
