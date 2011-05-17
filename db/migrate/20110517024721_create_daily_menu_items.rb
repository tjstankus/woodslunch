class CreateDailyMenuItems < ActiveRecord::Migration
  def self.up
    create_table :daily_menu_items do |t|
      t.integer :day_of_week_id
      t.integer :menu_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_menu_items
  end
end
