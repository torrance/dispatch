ActiveAdmin.register Content do
  actions :all, :except => :new

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
    default_actions
  end

  form do |f|
    f.inputs "Edit content" do
      f.input :title
      f.input :summary
      f.input :body
      f.input :category, :as => :select, :collection => Content::CATEGORIES
      f.input :tag_list
      if f.object.type == 'Event'
        f.input :start
        f.input :location
      end
      f.input :status, :as => :select, :collection => Content::STATES.each_with_index.map{ |state, i| [state, i] }
      f.input :pseudonym
      f.input :user
      f.input :created_at
    end
  end
end