class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards, id: :uuid do |t|
      t.references :column, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.integer :position
      t.references :assignee, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
