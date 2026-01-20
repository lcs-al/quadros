class ChangeColumnIdInCardsToNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :cards, :column_id, true
  end
end
