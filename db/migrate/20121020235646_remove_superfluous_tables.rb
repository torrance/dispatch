class RemoveSuperfluousTables < ActiveRecord::Migration
  def up
    drop_table :events
    drop_table :pages
    drop_table :reposts
  end
end
