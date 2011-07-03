class CreateAccountRequests < ActiveRecord::Migration
  def self.up
    create_table :account_requests do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :state
      t.string :activation_token
      t.timestamp :approved_at
      t.timestamp :declined_at

      t.timestamps
    end
  end

  def self.down
    drop_table :account_requests
  end
end
