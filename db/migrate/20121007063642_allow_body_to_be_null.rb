class AllowBodyToBeNull < ActiveRecord::Migration
  def change
    change_column :contents, :body, :text, :null => true
  end
end
