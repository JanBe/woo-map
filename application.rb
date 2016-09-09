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

  JSON(HTTPI.post(request).body)['items'].collect do |session|
    {
      max_air_time: session['maxAirTime'],
      highest_air: session['highestAir'],
      max_crash_power: session['maxCrashPower'],
      user_first_name: session['user_name'],
      user_last_name: session['user_lastname'],
      created: session['created'],
      time: session['time'],
      spot: find_spot(session['_spot']['$id'])
    }
  end.to_json
end

def token
  request = HTTPI::Request.new(url: "#{ENV['WOO_TOKEN_APP_URL']}/tokens/latest")
  response = HTTPI.get(request)
  JSON(response.body)['access_token']
end

def find_spot(id)
  spot = spots.find {|s| s['id'] == id }
  unless spot.nil?
    {
      name: spot['properties']['name'],
      location: {
        lat: spot['geometry']['coordinates'][0],
        lon: spot['geometry']['coordinates'][1]
      }
    }
  else
    {}
  end
end

def spots
  @spots ||= get_spots
end

def get_spots
  request = HTTPI::Request.new(url: "#{ENV['WOO_EXPLORE_URL']}/output.geojson")
  JSON(HTTPI.get(request).body)
end
