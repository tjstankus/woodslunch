class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.date :served_on
      t.integer :student_id
      t.integer :user_id
      t.string :type
      t.decimal :total, :precision => 5, :scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
