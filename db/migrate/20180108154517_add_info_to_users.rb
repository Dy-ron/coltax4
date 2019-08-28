class AddInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cia, :string
    add_column :users, :car, :string
  end
end
