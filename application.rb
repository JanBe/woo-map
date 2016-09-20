Bundler.require :default
require './config/environments'
require './lib/json'

Dir['./models/**/*.rb'].each { |file| require file }
Dir['./serializers/**/*.rb'].each { |file| require file }

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

  load_spots
  load_new_sessions

  last_updated_at = Time.at(params[:last_updated_at].to_i) if params[:last_updated_at].present?
  json Session.where('posted_at > ?', last_updated_at || (Time.now - 60 * 60 * 24))
end

def load_new_sessions
  seconds_since_sessions_updated = Time.now - (Session.pluck(:updated_at).last || 60 * 60 * 24)
  if seconds_since_sessions_updated > 900
    load_new_sessions_since(Time.now - seconds_since_sessions_updated)
    Session.last.touch
  end
end

def load_new_sessions_since(break_time)
  token = get_token
  break_time_reached = false

  (0..200).step(15).collect do |offset|
    break if break_time_reached

    request = HTTPI::Request.new(
      url: "#{ENV['WOO_PRODUCTION_API_URL']}/session/activity",
      body: {
        token: token,
        offset: offset,
        pageSize: 15,
        target: 'community'
      }
    )
    JSON(HTTPI.post(request).body)['items'].each do |api_session|
      posted_at = Time.at(api_session['created']).to_datetime

      if posted_at < break_time
        break_time_reached = true
        break
      end

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
        session.posted_at = posted_at
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
  end
end

def load_spots
  if Spot.none? || (Spot.last.updated_at < (Time.now - 60 * 60 * 24))
    request = HTTPI::Request.new(url: "#{ENV['WOO_EXPLORE_URL']}/output.geojson")
    JSON(HTTPI.get(request).body).map do |api_spot|
      Spot.find_or_initialize_by(woo_id: api_spot['id']) do |spot|
        spot.name = api_spot['properties']['name']
        spot.location_lng = api_spot['geometry']['coordinates'][0]
        spot.location_lat = api_spot['geometry']['coordinates'][1]
        spot.save
      end
    end
    Spot.last.touch
  end
end

def get_token
  request = HTTPI::Request.new(url: "#{ENV['WOO_TOKEN_APP_URL']}/tokens/latest")
  response = HTTPI.get(request)
  JSON(response.body)['access_token']
end
