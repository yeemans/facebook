class CreateFriendRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :friend_requests do |t|
      t.references :friend_1
      t.references :friend_2
      t.timestamps
    end
  end
end
