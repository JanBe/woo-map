require 'sinatra'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rack/env'
require 'httpi'
require 'pry'

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
      max_airtime: format_duration(session['maxAirTime']),
      highest_jump: session['highestAir'],
      total_height: session['totalHeight'],
      total_airtime: format_duration(session['totalAirTime']),
      duration: format_duration(session['duration']),
      number_of_jumps: session['numberOfAirs'],
      description: session['name'],
      max_crash_power: session['maxCrashPower'],
      user_name: "#{session['user_name']} #{session['user_lastname']}",
      session_posted: Time.at(session['created']).strftime('%a %b %d, %k:%M'),
      session_finished: Time.at(session['time']).strftime('%a %b %d, %k:%M'),
      spot: find_spot(session['_spot']['$id']),
      likes: session['totallikes'],
      comments: session['totalcomments'],
      user_pictures: session['user_pictures'].collect {|p| {p['type'] => p['url']} }.reduce(&:merge),
      picture: session['_pictures'].any? ? session['_pictures'][0]['url'] : nil
    }
  end.to_json
end

def format_duration(seconds)
  time = Time.new(2016,01,01,0,0) + seconds
  if seconds < 60
    time.strftime('%-S.%1Ns')
  elsif seconds < 3600
    time.strftime('%-Mm %-Ss')
  else
    time.strftime('%-kh %-Mm %-Ss')
  end
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
        lat: spot['geometry']['coordinates'][1],
        lng: spot['geometry']['coordinates'][0]
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
