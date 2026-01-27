class CreateBoardMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :board_memberships, id: :uuid do |t|
      t.references :board, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :board_memberships, %i[board_id user_id], unique: true
  end
end
