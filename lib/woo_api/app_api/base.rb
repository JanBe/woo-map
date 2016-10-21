module WooApi
  module AppApi
    class Base
      def self.build_request(path, configuration = {})
        local_configuration = configuration.dup
        if local_configuration[:token_auth]
          local_configuration[:token] = current_access_token
          local_configuration.delete(:token_auth)
        end
        HTTPI::Request.new(url: "#{WooApi::AppApi::BASE_URL}#{path}", body: local_configuration)
      end

      private

      def self.current_access_token
        last_token = WooAppApiToken.last.access_token
        if WooAppApiToken.any? && WooAppApiToken.last.expires_at > Time.current && access_token_valid?(last_token)
          last_token
        else
          WooApi::AppApi::User.login
          current_access_token
        end
      end

      def self.access_token_valid?(access_token)
        response = HTTPI.post(HTTPI::Request.new(url: "#{WooApi::AppApi::BASE_URL}/session/activity", body: {token: access_token, pageSize: 1}))
        response.code == 200
      end

      def self.parse_response_items(response)
        JSON(response.body)['items']
      end
    end
  end
end
