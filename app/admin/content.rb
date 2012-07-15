ActiveAdmin.register Content do
  actions :all, :except => [:new]

  filter :type, :as => :select, :collection => [['Article', 'Article'], ['Event', 'Event'], ['Repost', 'Repost']]
  filter :title
  filter :category, :as => :select, :collection => Content::CATEGORIES
  filter :status, :as => :select, :collection => Content::STATES.each_with_index.map{ |state, i| [state, i] }
  filter :user_display_name, :as => :string
  filter :pseudonym
  filter :start, :label => "Start date (events only)"
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :title do |content|
      link_to content.title, content
    end
    column :type
    column :category
    column :user do |content|
      if content.user
        link_to content.author_name, admin_user_path(content.user)
      else
        content.author_name
      end
    end
    column :status do |content|
      Content::STATES[content.status]
    end
    column :created_at
    column :updated_at
    column 'Actions' do |content|
      view = link_to 'View', content
      edit = link_to 'Edit', [:edit, content]
      delete = link_to 'Delete', admin_content_path(content), :method => :delete, :data => { :confirm => 'Are you sure you want to delete this content?' }
      "#{view} #{edit} #{delete}".html_safe
    end
  end
end