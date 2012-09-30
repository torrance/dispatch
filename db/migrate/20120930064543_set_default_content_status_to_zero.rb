class SetDefaultContentStatusToZero < ActiveRecord::Migration
  def up
    change_column :contents, :status, :integer, :null => false, :default => 0
  end
end
