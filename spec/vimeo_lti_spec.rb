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

  describe "GET /api/video/:video_id" do
    it "should return vimeo video data" do
      id = 7100569
      get "/api/video/#{7100569}"

      video = JSON.parse(last_response.body)
      video['title'].should == 'Brad!'
      video['duration'].should == '118'
      video['description'].should == 'Brad finally gets the attention he deserves.'
    end
  end

  describe "GET /api/video/:video_id/oembed" do
    it "should return the oembed JSON response" do
      id = 7100569
      get "/api/video/#{7100569}/oembed"

      video = JSON.parse(last_response.body)
      video['type'].should == 'video'
      video['title'].should == 'Brad!'
      video['duration'].should == 118
      video['description'].should == 'Brad finally gets the attention he deserves.'
    end
  end
end