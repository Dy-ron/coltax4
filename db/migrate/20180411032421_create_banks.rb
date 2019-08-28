class CreateBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :banks do |t|
      t.string :bank_id
      t.string :bank

      t.numeric :puc
      t.string :trans_type
      t.text :detail
      t.numeric :trans_value
      t.numeric :balance

      t.references :users, foreign_key: true
      t.boolean :verified

      t.timestamps
    end
  end
end
