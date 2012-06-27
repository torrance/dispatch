class AddToAndFromDatesAndLocationFieldToContents < ActiveRecord::Migration
  def change
    add_column :contents, :datetime_from, :datetime
    add_column :contents, :datetime_to, :datetime
    add_column :contents, :location, :string
  end
end
