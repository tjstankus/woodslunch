module AccountHelpers

  def create_account_request(options = {})
    options.reverse_merge!({:students => 1})
    Factory(:account_request).tap do |acc_req|
      [].tap do |a|
        options[:students].times do
          a << Factory(:requested_student, :account_request => acc_req)
        end
      end
    end
  end
end