class CreateServiceRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :service_requests do |t|
      t.references :service, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :lawyer, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :service_requests, :status
  end
end
