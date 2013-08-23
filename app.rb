ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym
require 'active_support/core_ext'

require_relative 'config/environments'
Dir[File.join("./lib", "**/*.rb")].each do |f|
  require f
end

class VinzApp < Sinatra::Base
  require 'rack/csrf'
  require 'rack/flash'

  configure do
    use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'] || 'Sssshh its a secret'
    use Rack::Csrf
    use Rack::Flash
    use Rack::MethodOverride
  end

  helpers Sinatra::App::Helpers

  register Sinatra::App::Dashboard
  register Sinatra::App::Session
  #register Sinatra::App::Users
  register Sinatra::App::ConfigItems
  register Sinatra::App::Consumers
  register Sinatra::App::Admin

end

class VinzAPI < Sinatra::Base
  helpers Sinatra::API::Helpers

  register Sinatra::API::Organizations
  register Sinatra::API::Users
  register Sinatra::API::Consumers
  register Sinatra::API::ConfigItems

  set(:methods) do |*methods|
    methods = [methods].flatten
    condition { methods.include?(request.request_method.upcase) }
  end
  before methods: %w{POST PUT} do
    parse_json_body
  end

  get '/' do
    'test'
  end

end
