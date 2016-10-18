module WooApi
  module AppApi
    class Session < Base
      RESOURCE_PATH = '/session'

      def self.useractivity(user, options={offset: 0, pageSize: 10})
        parse_response_items(HTTPI.post(build_request("#{RESOURCE_PATH}/useractivity/#{user.woo_id}", {token_auth: true}.merge(options))))
      end

      def self.activity(options={offset: 0, pageSize: 15})
        parse_response_items(HTTPI.post(build_request("#{RESOURCE_PATH}/activity", {token_auth: true, target: 'community'}.merge(options))))
      end
    end
  end
end

