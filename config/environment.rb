$:.unshift(File.expand_path('../../', __FILE__))

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)
require 'sinatra/base'
require 'rack/lti'
require 'find'
require 'json'
require 'vimeo'
require 'oembed'

%w{config/initializers lib}.each do |path|
  Find.find(path) { |f| require f if File.extname(f) == '.rb' }
end

require 'vimeo_lti'
