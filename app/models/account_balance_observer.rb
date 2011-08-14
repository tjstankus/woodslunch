class AccountBalanceObserver < ActiveRecord::Observer
  observe OrderedMenuItem

  def before_save(model)
    if model.total_changed?
      diff = model.total - model.total_was
      account = model.account
      account.change_balance_by(diff)
    end
  end

  def before_destroy(model)
    account = model.account
    account.change_balance_by(-model.total)
  end
end
