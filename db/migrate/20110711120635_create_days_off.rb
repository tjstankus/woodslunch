class CreateDaysOff < ActiveRecord::Migration
  def self.up
    create_table :days_off do |t|
      t.date :starts_on
      t.date :ends_on
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :days_off
  end
end
