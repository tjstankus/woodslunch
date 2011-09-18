class CreateAccountTransactions < ActiveRecord::Migration
  def self.up
    create_table :account_transactions do |t|
      t.integer :account_id
      t.string :type
      t.decimal :amount, :precision => 5, :scale => 2, :default => 0
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :account_transactions
  end
end
