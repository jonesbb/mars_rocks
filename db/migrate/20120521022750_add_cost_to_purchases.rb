class AddCostToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :cost, :integer
  end
end
