module WooApi
  module AppApi
    class User < Base
      RESOURCE_PATH = '/user'

      def self.login
        request = build_request("#{RESOURCE_PATH}/login", {
          email: ENV['WOO_APP_API_EMAIL'],
          pass: Digest::SHA512.new.update(ENV['WOO_APP_API_PASSWORD'])
        })
        response = HTTPI.post(request)
        json_body = JSON(response.body)
        if response.code == 200
          save_access_token(json_body)
        end
        response
      end

      # when no user is supplied, the users' own profile is returned
      def self.profile(user=nil)
        HTTPI.post(build_request("#{RESOURCE_PATH}profile/#{user.woo_id}", token_auth: true))
      end

      def self.search(options={query: '', offset: 0, pageSize: 10})
        HTTPI.post(build_request("#{RESOURCE_PATH}search", {token_auth: true}.merge(options)))
      end

      private

      def self.save_access_token(json_body)
        WooAppApiToken.create({
          access_token: json_body['access_token'],
          expires_at: json_body['expires_in'].seconds.from_now - 1.hour,
          scope: json_body['scope'],
          refresh_token: json_body['refresh_token']
        })
      end
    end
  end
end
