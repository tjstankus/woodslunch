require "spec_helper"

describe AccountInvitationMailer do
  describe "invitation" do
    let(:mail) { AccountInvitationMailer.invitation }

    it "renders the headers" do
      pending
      # mail.subject.should eq("Invitation")
      # mail.to.should eq(["to@example.org"])
      # mail.from.should eq(["from@example.com"])
    end

    it "include url in body" do
      pending
      # mail.body.encoded.should include(url)
    end
  end

end
