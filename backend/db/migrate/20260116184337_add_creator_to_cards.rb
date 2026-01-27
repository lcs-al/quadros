class AddCreatorToCards < ActiveRecord::Migration[7.1]
  def change
    add_reference :cards, :creator, null: true, foreign_key: { to_table: :users }, type: :uuid
  end
end
