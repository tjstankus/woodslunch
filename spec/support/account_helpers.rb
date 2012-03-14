module AccountHelpers

  def create_account_request(options = {})
    options.reverse_merge!({:students => 1})
    # TODO: Simplify Array.new(num)
    Factory(:account_request).tap do |acc_req|
      [].tap do |a|
        options[:students].times do
          a << Factory(:requested_student, :account_request => acc_req)
        end
      end
    end
  end

  def create_student
    account = Factory(:account)
    user = Factory(:user, :account => account)
    Factory(:student, :account => account)
  end
end