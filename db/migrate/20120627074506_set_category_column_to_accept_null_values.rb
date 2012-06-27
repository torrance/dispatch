class SetCategoryColumnToAcceptNullValues < ActiveRecord::Migration
  def change
    change_column :contents,  :category, :string, :null => true
  end
end
