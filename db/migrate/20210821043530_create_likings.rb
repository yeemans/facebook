class CreateLikings < ActiveRecord::Migration[6.1]
  def change
    create_table :likings do |t|
      t.references :liking_user, class_name: "User"
      t.references :liked_post, class_name: "Post"
      t.timestamps
    end
  end
end
