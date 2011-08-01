class CreateStudentOrders < ActiveRecord::Migration
  def self.up
    create_table :student_orders do |t|
      t.date :starts_on
      t.date :ends_on
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :student_orders
  end
end
