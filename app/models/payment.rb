class Payment < AccountTransaction

  def update_balance_for_save
    account.change_balance_by(-amount)
  end

  def update_balance_for_destroy
    account.change_balance_by(amount)
  end
end
