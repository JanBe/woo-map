module WooApi
  module ExploreApi
    class Spot
      def self.all
        request = HTTPI::Request.new(url: "#{BASE_URL}/output.geojson")
        JSON(HTTPI.get(request).body)
      end
    end
  end
end
