class AddIndexesForAccountsSearch < ActiveRecord::Migration
  def self.up
    add_index(:users, :account_id)
    add_index(:students, :account_id)
    add_index(:students, :first_name)
    add_index(:students, :last_name)
  end

  def self.down
    remove_index(:users, :account_id)
    remove_index(:students, :account_id)
    remove_index(:students, :first_name)
    remove_index(:students, :last_name)
  end
end
