class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.float :amount
      t.integer :quantity

      t.timestamps
    end
  end
end
