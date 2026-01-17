class AddCardTypeToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :card_type, :integer, default: 1
  end
end
