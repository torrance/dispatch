class DropUserSessionsTable < ActiveRecord::Migration
  def up
    drop_table :user_sessions
  end
end
