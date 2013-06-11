require 'spec_helper'

describe VimeoLti do
  describe "POST /lti_tool" do

    it "should require consumer key" do
      post '/lti_tool', {}
      last_response.should be_ok
      last_response.body.should include 'No consumer key'
    end

  end
end