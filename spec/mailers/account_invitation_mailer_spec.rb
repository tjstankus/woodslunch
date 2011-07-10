require "spec_helper"

describe AccountInvitationMailer do

  let(:token) { SecureRandom.hex(16) }
  let(:account_request) {
    Factory(:account_request, :activation_token => token)
  }
  let(:mail) {
    AccountInvitationMailer.invitation(account_request)
  }

  describe "invitation" do

    # it "renders the headers" do
    #   pending
    #   mail.subject.should eq("Invitation")
    #   mail.to.should eq(["to@example.org"])
    #   mail.from.should eq(["from@example.com"])
    # end

    it "includes activation url in body" do
      url = "http://example.com/account_requests/#{account_request.id}" +
          "/activations/new?token=#{token}"
      mail.body.encoded.should include(url)
    end
  end

end
