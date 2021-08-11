class ApplicationController < ActionController::API
    def encode_token
        JWT.encode(payload, 'my_secret')
    end
end
