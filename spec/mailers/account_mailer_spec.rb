require "spec_helper"

describe AccountMailer do

  let(:token) { SecureRandom.hex(16) }
  let(:account_request) {
    Factory(:account_request, :activation_token => token)
  }
  let(:mail) {
    AccountMailer.activation(account_request)
  }

  describe "activation" do

    # it "renders the headers" do
    #   mail.subject.should match(/activation/i)
    #   mail.to.should eq([account_request.email])
    #   mail.from.should eq(["Lunch@example.com"])
    # end

    it "includes activation url in body" do
      url = "http://example.com/account_requests/#{account_request.id}" +
          "/activations/new?token=#{token}"
      mail.body.encoded.should include(url)
    end
  end

end
