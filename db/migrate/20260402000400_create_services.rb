class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.integer :price_cents, null: false, default: 0
      t.boolean :published, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :services, :slug, unique: true
    add_index :services, :title, unique: true
  end
end
