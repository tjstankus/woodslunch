class AccountBalanceObserver < ActiveRecord::Observer
  observe OrderedMenuItem

  # def after_create(model)
  #   account = model.get_account
  #   account.change_balance_by(model.total)
  # end

  # def after_update(model)
  #   if model.total_changed?
  #     diff = model.total - model.total_was
  #     account = model.get_account
  #     account.change_balance_by(model.total)
  #   end
  # end

  def before_save(model)
    if model.total_changed?
      diff = model.total - model.total_was
      account = model.get_account
      account.change_balance_by(diff)
    end
  end

  def before_destroy(model)
    account = model.get_account
    account.change_balance_by(-model.total)
  end
end
