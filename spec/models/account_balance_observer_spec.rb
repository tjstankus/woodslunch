require 'spec_helper'

describe AccountBalanceObserver do

  context 'given a new observed object' do

    it 'updates balance on create' do
      price = 4.00
      menu_item = Factory(:menu_item, :price => price)
      ordered_menu_item = Factory.build(:ordered_menu_item,
                                        :menu_item => menu_item,
                                        :quantity => 1)
      account = ordered_menu_item.account
      expect {
        ordered_menu_item.save
      }.to change { account.balance }.from(0).to(price)
    end
  end

  context 'given an existing observed object' do

    let(:price) { 4.50 }
    let!(:menu_item) { Factory(:menu_item, :price => price) }
    let(:quantity) { 1 }
    let!(:ordered_menu_item) { Factory(:ordered_menu_item,
                                       :quantity => quantity,
                                       :menu_item => menu_item) }
    let!(:account) { ordered_menu_item.account }

    it 'updates balance on update' do
      expect {
        ordered_menu_item.update_attributes(:quantity => quantity + 1)
      }.to change { account.balance }.by(price)
    end

    it 'updates balance on destroy' do
      expect {
        ordered_menu_item.destroy
      }.to change { account.balance }.by(-price)
    end
  end

end
