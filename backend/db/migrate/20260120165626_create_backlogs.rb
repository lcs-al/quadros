class CreateBacklogs < ActiveRecord::Migration[7.1]
  def change
    create_table :backlogs, id: :uuid do |t|
      t.references :board, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
