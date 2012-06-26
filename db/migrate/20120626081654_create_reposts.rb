class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|

      t.timestamps
    end
  end
end
