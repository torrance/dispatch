class RenameArticlesTableToContent < ActiveRecord::Migration
  def change
    rename_table :articles, :contents
    add_column :contents, :type, :string, :null => false, :default => 'article'
  end
end
