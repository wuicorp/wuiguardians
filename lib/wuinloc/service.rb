module Wuinloc
  class Service
    def self.wuinloc_service
      @wuinloc_service ||= new
    end

    def save_flag(params = {})
      post('/flags', params)
    end

    def post(path, params)
      access_token.post(versioned_path(path), params: params)
    end

    def access_token
      @access_token ||= client.client_credentials.get_token
    end

    def client
      @client ||= OAuth2::Client.new(Wuinloc.client_id,
                                     Wuinloc.client_secret,
                                     site: Wuinloc.site,
                                     token_url: token_url)
    end

    private

    def versioned_path(resource_path)
      "#{version_path}#{resource_path}"
    end

    def version_path
      @version_path ||= '/api/v1'
    end

    def token_url
      @token_url ||= "#{version_path}/oauth/token"
    end
  end
end
