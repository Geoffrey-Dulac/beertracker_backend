class BeersController < ApplicationController
    before_action :authorized

    # /beers
    def index
        user = User.find_by(id: decoded_token[0]['user_id'])
        render json: { username: user.username }
    end
end
