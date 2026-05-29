class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :posts, :published
  end
end
