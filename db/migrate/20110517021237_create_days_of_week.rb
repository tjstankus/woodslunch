class CreateDaysOfWeek < ActiveRecord::Migration
  def self.up
    create_table :days_of_week do |t|
      t.string :name
    end

    add_index :days_of_week, :name, :unique => true
  end

  def self.down
    remove_index :days_of_week, :name
    drop_table :days_of_week
  end
end
