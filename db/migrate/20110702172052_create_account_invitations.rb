class CreateAccountInvitations < ActiveRecord::Migration
  def self.up
    create_table :account_invitations do |t|
      t.integer :account_request_id
      t.string :token
    end
  end

  def self.down
    drop_table :account_invitations
  end
end
