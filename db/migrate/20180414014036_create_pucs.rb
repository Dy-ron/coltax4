class CreatePucs < ActiveRecord::Migration[5.0]
  def change
    create_table :pucs do |t|
      t.numeric :code
      t.string :name
      t.string :puc_type
      t.text :detail
      t.string :puc_class
      t.string :category

      t.timestamps
    end
  end
end
