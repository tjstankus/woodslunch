require 'spec_helper'

describe "DaysOff" do

  describe "GET /days_off" do
    it "requires admin" do
      get days_off_path
      response.status.should be(302)
    end
  end

end
