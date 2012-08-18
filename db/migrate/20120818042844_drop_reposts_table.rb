class DropRepostsTable < ActiveRecord::Migration
  def down
    drop_table :reposts
  end
end
