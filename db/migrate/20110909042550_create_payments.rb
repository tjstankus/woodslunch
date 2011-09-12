class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :account_id
      t.decimal :amount, :precision => 5, :scale => 2, :default => 0
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
