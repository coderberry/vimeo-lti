$ns = NonceStore.instance

class AuthorizationFailureException < Exception; end

class VimeoLti < Sinatra::Base
  enable :sessions
  set :protection, :except => :frame_options

  set :consumer_key,    ENV['VIMEO_CONSUMER_KEY']
  set :consumer_secret, ENV['VIMEO_CONSUMER_SECRET']
  set :token,           ENV['VIMEO_TOKEN']
  set :secret,          ENV['VIMEO_SECRET']

  use Rack::LTI,
    consumer_key:    nil,
    consumer_secret: nil,
    title:           'Vimeo',
    description:     'Vimeo LTI application',
    nonce_validator: ->(nonce) { !$ns.include?(nonce, 60*60) },
    extensions: {
      'canvas.instructure.com' => {
        editor_button: {
          icon_url: "#{ENV['HOST']}/images/vimeo_icon.png",
          text: "Vimeo",
          selection_width: 500,
          selection_height: 500,
          enabled: true
        },
        resource_selection: {
          icon_url: "#{ENV['HOST']}/images/vimeo_icon.png",
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
    erb :index, :layout => false
  end

  get '/api/search' do
    content_type :json
    if params[:q]
      # return nil unless params[:q]
      begin
        criteria = {
          :page          => params[:page] || 1,
          :per_page      => 25,
          :full_response => 1,
          :sort          => params[:sort] || "relevant",
          :user_id       => nil
        }
        results = @client.search(params[:q], criteria)
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
    content_type :json
    results = @client.get_info(params[:video_id])
    begin
      results['video'].first.to_json
    rescue
      {}.to_json
    end
  end

  get '/api/video/:video_id/oembed' do
    content_type :json
    video_url = "http://vimeo.com/#{params[:video_id]}"
    oe = OEmbed::Providers::Vimeo.get(video_url)
    oe.fields.to_json
  end

  get '/api/choose/:video_id' do
    @query = {
      embed_type: 'iframe',
      url: "http://player.vimeo.com/video/#{params[:video_id]}",
      title: params[:title],
      width: 640,
      height: 380
    }
    if session[:launch_params]
      base_url = session[:launch_params]['launch_presentation_return_url']
      base_url += (url.include?('?') ? '&' : '?')
      redirect "#{base_url}#{hash_to_querystring(@query)}"
    else
      erb :redirected
    end
  end

   def hash_to_querystring(hash)
    hash.keys.inject('') do |query_string, key|
      query_string << '&' unless key == hash.keys.first
      query_string << "#{URI.escape(key.to_s)}=#{URI.escape(hash[key].to_s)}"
    end
  end

end