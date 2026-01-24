class AddCompletedAtToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :completed_at, :datetime
    add_index :cards, :completed_at
  end
end
