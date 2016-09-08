require 'sinatra'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rack/env'

use Rack::Env unless ENV['RACK_ENV'] == 'production'

get '/' do
  slim :index
end

get '/map.js' do
  coffee :map
end

get '/map.css' do
  sass :map
end
