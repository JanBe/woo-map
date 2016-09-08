require 'sinatra'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rack/env'
require 'httpi'

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

get '/sessions' do
  content_type :json
  request = HTTPI::Request.new(
    url: "#{ENV['WOO_PRODUCTION_API_URL']}/session/activity",
    body: {
      token: token,
      offset: 0,
      pageSize: 100,
      target: 'community'
    }
  )
  HTTPI.post(request).body
end

def token
  request = HTTPI::Request.new(url: "#{ENV['WOO_TOKEN_APP_URL']}/tokens/latest")
  response = HTTPI.get(request)
  JSON(response.body)['access_token']
end
