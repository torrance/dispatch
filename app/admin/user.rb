ActiveAdmin.register User do
  filter :display_name
  filter :email
  filter :active, :as => :select
  filter :id
  filter :role, :as => :select, :collection => User::ROLES.each_with_index.map{ |role, i| [role, i]}

  index do
    selectable_column
    column :id
    column :display_name do |user|
      link_to user.display_name, user
    end
    column :email
    column :role do |user|
      User::ROLES[user.role]
    end
    column :current_login_at
    column :created_at
    column :active do |user|
      user.active? ? "Yes" : "No"
    end
    default_actions
  end

  controller do
    with_role :editor
  end

  show do |user|
    attributes_table do
      row :display_name
      row :email
      row :id
      row :biography
      row :active do |user|
        user.active? ? "Yes" : "No"
      end
      row :role do |user|
        User::ROLES[user.role]
      end
      row :login_count
      row :failed_login_count
      row :current_login_at
      row :last_login_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "User details" do
      f.input :email
      f.input :display_name
      f.input :password, :label => "Change password"
      f.input :biography
      f.input :role, :as => :select, :collection => User::ROLES.each_with_index.map{ |role, i| [role, i]}
      f.input :active
    end
    f.buttons
  end
end
