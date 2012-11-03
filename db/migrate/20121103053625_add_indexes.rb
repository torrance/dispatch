class AddIndexes < ActiveRecord::Migration
  def change
    # Comments table
    add_index "comments", "user_id"
    add_index "comments", "content_id"
    add_index "comments", "created_at"
    add_index "comments", "status"
    add_index "comments", ["content_id", "status"]

    # Contents table
    add_index "contents", "created_at"
    add_index "contents", "user_id"
    add_index "contents", "hidden"
    add_index "contents", "status"

    # Images table
    add_index "images", "content_id"

    # Users table
    add_index "users", "email"
    add_index "users", "active"

    # Votes table
    add_index "votes", "content_id"
  end
end
