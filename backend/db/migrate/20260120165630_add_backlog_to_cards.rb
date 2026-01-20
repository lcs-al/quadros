class AddBacklogToCards < ActiveRecord::Migration[7.1]
  def change
    add_reference :cards, :backlog, null: true, foreign_key: true
  end
end
