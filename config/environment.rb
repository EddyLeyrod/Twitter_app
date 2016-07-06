# Hace require de los gems necesarios.
# Revisa: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
# Require gems we care about

require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'
require 'twitter'

require 'openssl'
require 'sinatra'
require 'oauth'


OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Configura los controllers y los helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'uploaders', '*.rb')].each { |file| require file }

# Configura la base de datos y modelos 
require APP_ROOT.join('config', 'database')

CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = "i60kKMg8TmviwcowX1ylg0qfX"
  config.consumer_secret     = "cwPlytnJtFX99tgYw8cGb6zaaUosS9fAFUSUdiWteZdQ881ul4"
  config.access_token        = "531892136-9E3UGdCzWFUQcAQxAAD7HcMhypGElU5fF0roYpGP"
  config.access_token_secret = "d3u9saVhYo4fKbYCCIjpctN8J46Bjd0E2eRR4Aine7yS6"
end