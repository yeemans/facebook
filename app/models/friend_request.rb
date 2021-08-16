class FriendRequest < ApplicationRecord
  belongs_to :friend_1, class_name: "User"
  belongs_to :friend_2, class_name: "User"
end
