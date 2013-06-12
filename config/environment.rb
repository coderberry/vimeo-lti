$:.unshift(File.expand_path('../../', __FILE__))

ENV['RACK_ENV'] ||= 'development'
env_file_path = File.expand_path("../env.rb", __FILE__)
if File.exists?(env_file_path)
  puts "Loading ENV variables"
  require env_file_path
end

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)
require 'sinatra/base'
require 'rack/lti'
require 'find'
require 'json'
require 'vimeo'
require 'oembed'

%w{lib}.each do |path|
  Find.find(path) { |f| require f if File.extname(f) == '.rb' }
end

require 'vimeo_lti'
