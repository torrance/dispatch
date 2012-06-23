class ChangeArticleIdToContentId < ActiveRecord::Migration
  def change
    rename_column :images, :article_id, :content_id
  end
end
