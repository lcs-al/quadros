class CreateBacklogs < ActiveRecord::Migration[7.1]
  def change
    create_table :backlogs do |t|
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
