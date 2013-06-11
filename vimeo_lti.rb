require 'sinatra/base'
require 'ims/lti'
require 'oauth/request_proxy/rack_request' # must include the oauth proxy object

class VimeoLti < Sinatra::Base
  
  set :protection, :except => :frame_options
  set :secret, 'e98dda657a78777e62afd312eb0719ba'

  # endpoints ..............................................................................................
  
  get '/' do
    erb :index
  end

  post '/lti_tool' do
    authorize!

    # erb :_params
  end

  # methods ................................................................................................

  def show_error(message)
    @message = message
    erb :error
  end

  def authorize!
    if key = params['oauth_consumer_key']
      @tp = IMS::LTI::ToolProvider.new(key, secret, params)
    else
      return show_error "No consumer key"
    end
  end

end