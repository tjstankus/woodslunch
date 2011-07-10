class AccountInvitationMailer < ActionMailer::Base
  default :from => "Lunch@woodscharter.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account_invitation_mailer.invitation.subject
  #
  def invitation(account_request, options={})
    options.reverse_merge!(:host => 'woodslunch.dev')
    @url = new_account_request_activation_url(account_request,
        :token => account_request.activation_token, :host => options[:host])

    mail(:to => account_request.email,
        :subject => 'Woods Charter School Lunch Program -- Account Activation')
  end
end
