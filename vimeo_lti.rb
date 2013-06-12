$ns = NonceStore.instance

class AuthorizationFailureException < Exception; end

class VimeoLti < Sinatra::Base
  
  enable :sessions
  set :protection, :except => :frame_options

  set :consumer_key,    VIMEO_CONFIG['consumer_key']
  set :consumer_secret, VIMEO_CONFIG['consumer_secret']
  set :token,           VIMEO_CONFIG['token']
  set :secret,          VIMEO_CONFIG['secret']

  use Rack::LTI,
    consumer_key:    nil,
    consumer_secret: nil,
    title:           'Vimeo',
    description:     'Vimeo LTI application',
    nonce_validator: ->(nonce) { !$ns.include?(nonce, 60*60) },
    extensions: {
      'canvas.instructure.com' => {
        editor_button: {
          url: "http://vimeo-lti.herokuapp.com/",
          icon_url: "http://vimeo-lti.herokuapp.com/images/vimeo_icon.png",
          text: "Vimeo",
          selection_width: 500,
          selection_height: 500,
          enabled: true
        },
        resource_selection: {
          url: "http://vimeo-lti.herokuapp.com/",
          icon_url: "http://vimeo-lti.herokuapp.com/images/vimeo_icon.png",
          text: "Vimeo",
          selection_width: 500,
          selection_height: 500,
          enabled: true
        }
      }
    }

  def initialize
    super
    @client ||= Vimeo::Advanced::Video.new(settings.consumer_key, settings.consumer_secret, :token => settings.token, :secret => settings.secret)
  end

  get '/' do
    puts session.inspect
    # if session[:launch_params]
      erb :index, :layout => false
    # else
    #   erb :instructions
    # end
  end

  get '/api/search' do
    puts session.inspect

    content_type :json
    if params[:q]
      # return nil unless params[:q]
      begin
        results = @client.search(params[:q], {
          :page          => params[:page] || 1,
          :per_page      => 24,
          :full_response => 1,
          :sort          => params[:sort] || "relevant",
          :user_id       => nil
        })
        results['videos']['video'].to_json
      rescue => ex
        puts ex.inspect
        [].to_json  
      end
    else
      [].to_json
    end
  end

  get '/api/video/:video_id.?:format?' do

    puts session.inspect

    content_type :json
    results = @client.get_info(params[:video_id])
    begin
      results['video'].first.to_json
    rescue
      {}.to_json
    end
  end

  get '/api/video/:video_id/oembed' do
    puts session.inspect

    content_type :json
    video_url = "http://vimeo.com/#{params[:video_id]}"
    oe = OEmbed::Providers::Vimeo.get(video_url)
    oe.fields.to_json
  end

  get '/api/choose/:video_id' do
    @url = 'embed_type=oembed&url=http://vimeo.com/' + params[:video_id] + '&'
    @url += 'endpoint=http://vimeo.com/api/oembed.xml'
    if session[:launch_params]
      base_url = session[:launch_params]['launch_presentation_return_url']
      base_url += (url.include?('?') ? '&' : '?')
      redirect "#{base_url}#{@url}"
    else
      erb :redirected
    end
  end

end