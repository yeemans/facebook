class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :friend
t.timestamps
    end
  end
end