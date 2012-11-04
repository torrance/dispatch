class AddWeightColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :weight, :integer, :null => false, :default => 0
  end
end
