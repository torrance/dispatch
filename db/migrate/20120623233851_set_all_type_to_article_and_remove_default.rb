class SetAllTypeToArticleAndRemoveDefault < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE contents SET type = 'Article'
    SQL
    # Remove default 'article' value for type column
    change_column_default :contents, :type, :nil
  end
end
