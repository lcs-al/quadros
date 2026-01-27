class CreateColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :columns, id: :uuid do |t|
      t.references :board, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.integer :position

      t.timestamps
    end
  end
end
