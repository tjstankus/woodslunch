class CreateRequestedStudents < ActiveRecord::Migration
  def self.up
    create_table :requested_students do |t|
      t.integer :account_request_id
      t.string :first_name
      t.string :last_name
      t.string :grade
    end
  end

  def self.down
    drop_table :requested_students
  end
end
