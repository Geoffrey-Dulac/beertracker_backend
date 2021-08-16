class UserBeersController < ApplicationController
    before_action :authorized

    # /user_beers
    def user_beers
        user = User.find_by(id: decoded_token[0]['user_id'])
        user_beers_array = []
        UserBeer.where(user: user).each_with_index do |user_beer, index|
            data = {}
            data["#{index}"] = user_beer.beer 
            data[:user_grade] = user_beer.user_grade
            data[:brewer] = user_beer.beer.brewer
            user_beers_array << data
        end
        render json: { user_beers: user_beers_array, username: user.username }
    end
end
