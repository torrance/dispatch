class AddRepostPermissionColumnToContents < ActiveRecord::Migration
  def up
    add_column :contents, :repost_permission, :boolean
    # Set default value to true
    Repost.all.each do |r|
      r.update_attributes(:repost_permission => false)
    end
  end
end
