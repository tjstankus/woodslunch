class CreateOrderedMenuItems < ActiveRecord::Migration
  def self.up
    create_table :ordered_menu_items do |t|
      t.integer :menu_item_id
      t.integer :order_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ordered_menu_items
  end

end
