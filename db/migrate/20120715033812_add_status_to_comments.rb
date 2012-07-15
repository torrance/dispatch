class AddStatusToComments < ActiveRecord::Migration
  def change
    add_column :comments, :status, :integer, :null => false, :default => 1
  end
end
