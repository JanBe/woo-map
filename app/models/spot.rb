class Spot < ApplicationRecord
  has_many :sessions

  def self.find_or_initialize_by_api_data(api_spot)
    Spot.find_or_initialize_by(woo_id: api_spot['id']) do |spot|
      spot.name = api_spot['properties']['name']
      spot.location_lng = api_spot['geometry']['coordinates'][0]
      spot.location_lat = api_spot['geometry']['coordinates'][1]
    end
  end
end
