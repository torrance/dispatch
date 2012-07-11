ActiveAdmin.register Page do
  controller do
    defaults :finder => :find_by_path
  end

  index do
    selectable_column
    column :title do |page|
      link_to page.title, page
    end
    column :path
    column :created_at
    column :updated_at
    default_actions
  end

  show do |user|
    attributes_table do
      row :title do |page|
        link_to page.title, page
      end
      row :path
      row :created_at
      row :updated_at
    end
  end
end