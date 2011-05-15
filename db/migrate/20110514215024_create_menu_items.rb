class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table(:menu_items) do |t|
    	t.string :name
      t.text :description
      t.decimal :price, :precision => 5, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table(:menu_items)
  end
end
