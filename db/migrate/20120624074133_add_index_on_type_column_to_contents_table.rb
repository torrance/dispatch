class AddIndexOnTypeColumnToContentsTable < ActiveRecord::Migration
  def change
    add_index :contents, :type
  end
end
