Bundler.require :default
require './lib/json'

Dir['./models/**/*.rb'].each { |file| require file }
Dir['./serializers/**/*.rb'].each { |file| require file }

set :database_file, 'config/database.yml'
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
  token = get_token

  api_sessions = (0..100).step(15).collect do |offset|
    request = HTTPI::Request.new(
      url: "#{ENV['WOO_PRODUCTION_API_URL']}/session/activity",
      body: {
        token: token,
        offset: offset,
        pageSize: 15,
        target: 'community'
      }
    )
    JSON(HTTPI.post(request).body)['items']
  end.flatten!

  api_sessions.each do |api_session|
    Session.find_or_initialize_by(woo_id: api_session['_id']['$id']) do |session|
      session.max_airtime = api_session['maxAirTime']
      session.highest_jump = api_session['highestAir']
      session.total_height = api_session['totalHeight']
      session.total_airtime =  api_session['totalAirTime']
      session.duration = api_session['duration']
      session.number_of_jumps = api_session['numberOfAirs']
      session.description = api_session['name']
      session.max_crash_power = api_session['maxCrashPower']
      session.user_name = "#{api_session['user_name']} #{api_session['user_lastname']}"
      session.posted_at = Time.at(api_session['created']).to_datetime
      session.finished_at = Time.at(api_session['time']).to_datetime
      session.likes = api_session['totallikes']
      session.comments = api_session['totalcomments']
      session.spot_woo_id = api_session['_spot']['$id']
      api_session['user_pictures'].each do |api_picture|
        session.pictures.find_or_initialize_by(url: api_picture['url'], picture_type: api_picture['type'])
      end
      if api_session['_pictures'].any?
        session.pictures.find_or_initialize_by(url: api_session['_pictures'][0]['url'], picture_type: api_session['_pictures'][0]['type'])
      end
      session.save
    end
  end

  json Session.all
end

get '/load_spots' do
  content_type :json
  request = HTTPI::Request.new(url: "#{ENV['WOO_EXPLORE_URL']}/output.geojson")
  spots = JSON(HTTPI.get(request).body).map do |api_spot|
    Spot.find_or_initialize_by(woo_id: api_spot['id']) do |spot|
      spot.name = api_spot['properties']['name']
      spot.location_lng = api_spot['geometry']['coordinates'][0]
      spot.location_lat = api_spot['geometry']['coordinates'][1]
      spot.save
    end
  end
  json spots
end

def get_token
  request = HTTPI::Request.new(url: "#{ENV['WOO_TOKEN_APP_URL']}/tokens/latest")
  response = HTTPI.get(request)
  JSON(response.body)['access_token']
end
