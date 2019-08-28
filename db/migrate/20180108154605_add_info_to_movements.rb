class AddInfoToMovements < ActiveRecord::Migration[5.0]
  def change
    add_column :movements, :cia, :string
    add_column :movements, :car, :string
  end
end
