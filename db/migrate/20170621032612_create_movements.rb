class CreateMovements < ActiveRecord::Migration[5.0]
  def change
    create_table :movements do |t|
      t.integer :price
      t.string :type
      t.text :description

      t.timestamps
    end
  end
end
