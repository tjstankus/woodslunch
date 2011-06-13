class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :account_id
      t.string :first_name
      t.string :last_name
      t.string :grade
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
