class AddShortNameToMenuItems < ActiveRecord::Migration
  def self.up
    add_column(:menu_items, :short_name, :string)
  end

  def self.down
    remove_column(:menu_items, :short_name)
  end
end
