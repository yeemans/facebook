class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :notifier_id 
      t.integer :receiver_id
      t.string :text
      t.string :action
      t.timestamps
    end
  end
end
