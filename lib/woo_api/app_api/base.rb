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
        last_token = WooAppApiToken.last

        if last_token.present? && last_token.expires_at > Time.current && token_valid?(last_token)
          last_token.access_token
        else
          WooApi::AppApi::User.login
          current_access_token
        end
      end

      def self.token_valid?(token)
        response = HTTPI.post(HTTPI::Request.new(url: "#{WooApi::AppApi::BASE_URL}/session/activity", body: {token: token.access_token, pageSize: 1}))
        response.code == 200
      end

      def self.parse_response_items(response)
        JSON(response.body)['items']
      end
    end
  end
end
