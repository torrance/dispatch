ActiveAdmin.register Comment do
  actions :all, :except => [:new]

  filter :user_display_name, :as => :string
  filter :content_title, :as => :string
  filter :body
  filter :status, :as => :select, :collection => Comment::STATES.each_with_index.map{ |status, i| [status, i] }
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column 'Content' do |comment|
      link_to comment.content.title, comment.content
    end
    column 'User' do |comment|
      if comment.user
        link_to comment.user.display_name, admin_user_path(comment.user)
      end
    end
    column 'Status' do |comment|
      Comment::STATES[comment.status]
    end
    column :body do |comment|
      truncate comment.body, :length => 100, :separator => ' '
    end
    column :created_at
    column :updated_at
    column 'Actions' do |comment|
      view = link_to 'View', polymorphic_path(comment.content, :anchor => "comment-#{comment.id}")
      edit = link_to 'Edit', edit_admin_comment_path(comment)
      delete = link_to 'Delete', admin_comment_path(comment), :method => :delete, :data => { :confirm => 'Are you sure you want to delete this comment?' }
      "#{view} #{edit} #{delete}".html_safe
    end
  end

  form do |f|
    f.inputs "Edit comment" do
      f.input :body
      f.input :status, :as => :radio, :collection => Comment::STATES.each_with_index.map{ |status, i| [status, i] }
    end
    f.buttons
  end
end