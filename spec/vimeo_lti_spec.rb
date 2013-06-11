require 'spec_helper'

describe VimeoLti do
  describe "POST /lti/launch" do

    it "should not require consumer key" do
      post '/lti/launch', { 
        :consumer_key => nil,
        :oauth_nonce => 'whatever',
        :oauth_timestamp => Time.now.to_i
      }

      last_response.status.should == 301
    end

  end
end