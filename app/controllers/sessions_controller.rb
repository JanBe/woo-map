class SessionsController < ApplicationController
  def index
    oldest_allowed_post_time = if params[:last_updated_at].present?
      Time.at(params[:last_updated_at].to_i)
    else
      Time.now - 60 * 60 * 24
    end

    # We return all sessions that were posted since the client has last requested an update, and were not recorded more than 24 hours ago
    sessions = Session.where('posted_at > ? AND finished_at > ?', oldest_allowed_post_time, Time.now - 60 * 60 * 24)
    render json: sessions
  end
end
