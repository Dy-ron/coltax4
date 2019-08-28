class AddDateToMovements < ActiveRecord::Migration[5.0]
  def change
    add_column :movements, :mov_date, :date
    add_column :movements, :mov_hour, :string
  end
end
