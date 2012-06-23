class AddArticleIdToImagesTable < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.references :article
    end
  end
end
