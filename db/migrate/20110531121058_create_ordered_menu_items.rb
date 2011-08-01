class CreateOrderedMenuItems < ActiveRecord::Migration
  def self.up
    create_table :ordered_menu_items do |t|
      t.integer :menu_item_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :total, :precision => 5, :scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :ordered_menu_items
  end

end
