class AddPseudonymFieldToContentsTable < ActiveRecord::Migration
  def change
    add_column :contents, :pseudonym, :string
  end
end
