namespace :woo_api do
  task load_spots: :environment do
    WooApi::ExploreApi::Spot.all.each do |api_spot|
      Spot.find_or_initialize_by_api_data(api_spot).save
    end
  end

  task load_new_sessions: :environment do
    break_time = Session.pluck(:updated_at).last || (Time.current - 60 * 60 * 24)
    break_time_reached = false

    (0..500).step(15).collect do |offset|
      break if break_time_reached

      WooApi::AppApi::Session.activity({offset: offset, pageSize: 15}).each do |api_session|
        session = Session.find_or_initialize_by_api_data(api_session)
        if session.posted_at < break_time
          break_time_reached = true
          break
        end

        session.save
      end
    end
  end
end
