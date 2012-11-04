class RemoveEndDateFromEvents < ActiveRecord::Migration
  def up
    remove_column :contents, :end
  end
end
