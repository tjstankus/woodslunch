class AddInactiveStartsOnToMenuItems < ActiveRecord::Migration
  def self.up
    add_column(:menu_items, :inactive_starts_on, :date, :default => nil)
  end

  def self.down
    remove_column(:menu_items, :inactive_starts_on)
  end
end
