class User < ApplicationRecord
  has_many :sessions

  def self.find_or_initialize_by_api_session_data(api_session)
    find_or_initialize_by(woo_id: api_session['_user']['$id']) do |user|
      user.first_name = api_session['user_name']
      user.last_name = api_session['user_lastname']
      if api_session['user_pictures'].present?
        user.profile_picture_url = api_session['user_pictures'].find {|pic| pic['type'] == 'user'}.try(:[], 'url')
        user.cover_picture_url = api_session['user_pictures'].find {|pic| pic['type'] == 'cover'}.try(:[], 'url')
      end
    end
  end
end
