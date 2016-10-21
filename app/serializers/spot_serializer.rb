class SpotSerializer < ActiveModel::Serializer
  attributes :woo_id, :name, :location

  def location
    {
      lat: object.location_lat.to_f,
      lng: object.location_lng.to_f
    }
  end
end
