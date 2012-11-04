class AddModerationColumnToContents < ActiveRecord::Migration
  def change
    add_column :contents, :moderation, :integer, :null => false, :default => 1
    add_index :contents, :moderation
  end
end
