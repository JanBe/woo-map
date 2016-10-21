class Session < ApplicationRecord
  belongs_to :user, foreign_key: 'user_woo_id', primary_key: 'woo_id'
  belongs_to :spot, foreign_key: 'spot_woo_id', primary_key: 'woo_id'

  def self.find_or_initialize_by_api_data(api_session)
    find_or_initialize_by(woo_id: api_session['_id']['$id']) do |session|
      session.max_airtime = api_session['maxAirTime']
      session.highest_jump = api_session['highestAir']
      session.total_height = api_session['totalHeight']
      session.total_airtime =  api_session['totalAirTime']
      session.duration = api_session['duration']
      session.number_of_jumps = api_session['numberOfAirs']
      session.description = api_session['name']
      session.max_crash_power = api_session['maxCrashPower']
      session.posted_at = Time.at(api_session['created']).to_datetime
      session.finished_at = Time.at(api_session['time']).to_datetime
      session.likes = api_session['totallikes']
      session.comments = api_session['totalcomments']
      session.spot_woo_id = api_session['_spot']['$id']
      session.picture_url = api_session['_pictures'][0].try(:[], 'url')
      session.user = User.find_or_initialize_by_api_session_data(api_session)
    end
  end
end
