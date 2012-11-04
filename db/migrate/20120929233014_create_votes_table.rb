class CreateVotesTable < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user
      t.references :content, :null => false
      t.integer :vote, :null => false
      t.timestamps
    end
  end
end
