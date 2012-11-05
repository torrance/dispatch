class ContentsBodyFieldDefaultToBlank < ActiveRecord::Migration
  def up
    change_column :contents, :body, :text, :default => '', :null => false
  end
end
