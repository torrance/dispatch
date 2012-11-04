class ChangeEventDatetimeColumnNames < ActiveRecord::Migration
  def change
    rename_column :contents, :datetime_to, :end
    rename_column :contents, :datetime_from, :start
  end
end
