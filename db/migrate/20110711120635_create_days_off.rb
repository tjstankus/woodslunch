class CreateDaysOff < ActiveRecord::Migration
  def self.up
    create_table :days_off do |t|
      t.date :starts_on
      t.date :ends_on
      t.string :name
      t.timestamps
    end

    add_index :days_off, :starts_on, :unique => true
    add_index :days_off, :ends_on, :unique => true
  end

  def self.down
    drop_table :days_off
  end
end
