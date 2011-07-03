class AccountInvitationMailer < ActionMailer::Base
  default :from => "lunch@woodscharter.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account_invitation_mailer.invitation.subject
  #
  def invitation(account_invitation)
    @url = "http://example.com/"

    mail(:to => account_invitation.account_request.email,
        :subject => 'Woods Charter School Lunch Program -- Account Activation')
  end
end
