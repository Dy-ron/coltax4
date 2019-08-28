class AddTypeMovToMovements < ActiveRecord::Migration[5.0]
  def change
    add_column :movements, :mov_type, :string
  end
end
