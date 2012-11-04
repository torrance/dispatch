class AddHiddenFieldsToContent < ActiveRecord::Migration
  def up
    add_column :contents, :hidden, :boolean, :null => false, :default => false
    add_column :contents, :hidden_user_id, :integer

    # Push status data in new fields
    Content.all.each do |c|
      2.upto(c.status) { c.votes << Vote.new(:vote => 1) }

      if c.status == 0
        c.hidden = true
      end

      c.save
    end

  end
end
