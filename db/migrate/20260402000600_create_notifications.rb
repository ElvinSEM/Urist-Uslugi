class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.integer :channel, null: false, default: 0
      t.datetime :read_at
      t.references :notifiable, polymorphic: true

      t.timestamps
    end
  end
end
