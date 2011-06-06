class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.decimal :balance, :precision => 5, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
