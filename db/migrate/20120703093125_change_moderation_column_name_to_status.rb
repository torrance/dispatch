class ChangeModerationColumnNameToStatus < ActiveRecord::Migration
  def change
    rename_column :contents, :moderation, :status
  end
end
