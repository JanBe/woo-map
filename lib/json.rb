module Sinatra
  class Application
    def json(object, options={})
      serializer = ActiveModel::Serializer.serializer_for(object, options)
      if serializer
        serializer.new(object, options).to_json
      else
        object.to_json(options)
      end
    end
  end
end
