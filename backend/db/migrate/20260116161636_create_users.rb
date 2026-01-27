class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.integer :role

      t.timestamps
    end
    add_index :users, :email
  end
end
