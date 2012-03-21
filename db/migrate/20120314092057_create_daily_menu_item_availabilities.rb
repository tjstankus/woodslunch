class CreateDailyMenuItemAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :daily_menu_item_availabilities do |t|
      t.integer :daily_menu_item_id
      t.boolean :available
      t.date    :starts_on
      t.date    :ends_on
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_menu_item_availabilities
  end
end
