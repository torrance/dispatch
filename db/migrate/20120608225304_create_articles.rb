class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :summary, :null => false
      t.text :body, :null => false
      t.string :category, :null => false
      t.timestamps
    end
  end
end
