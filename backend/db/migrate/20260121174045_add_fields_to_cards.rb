class AddFieldsToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :priority, :integer, default: 0
    add_column :cards, :story_points, :integer
    add_column :cards, :due_date, :datetime
    add_column :cards, :labels, :json, default: []
  end
end
