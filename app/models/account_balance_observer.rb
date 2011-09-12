class AccountBalanceObserver < ActiveRecord::Observer
  observe OrderedMenuItem, Payment

  def before_save(model)
    account = model.account
    if model.has_attribute?(:total)
      if model.total_changed?
        diff = model.total - model.total_was
        account.change_balance_by(diff)
      end
    elsif model.has_attribute?(:amount)
      account.change_balance_by(-(model.amount))
    end
  end

  def before_destroy(model)
    account = model.account
    if model.has_attribute?(:total)
      account.change_balance_by(-model.total)
    elsif model.has_attribute?(:amount)
      account.change_balance_by(model.amount)
    end
  end
end
