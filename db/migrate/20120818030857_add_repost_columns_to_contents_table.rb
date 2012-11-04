class AddRepostColumnsToContentsTable < ActiveRecord::Migration
  def change
    add_column :contents, :url, :string
    add_column :contents, :url_name, :string
  end
end
