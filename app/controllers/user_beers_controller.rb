class UserBeersController < ApplicationController
    before_action :authorized

    # /user_beers
    def index
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

    # /create_user_beer
    def create
        userbeer = UserBeer.new
        userbeer.user = User.find_by(id: decoded_token[0]['user_id'])
        userbeer.beer = Beer.find_by(name: params[:name])
        userbeer.user_grade = params[:user_grade]
        if userbeer.save!
            render json: { status: 'success' }
        else 
            render json: { status: 'failed', message: "Impossible d'ajouter cette bière, merci de réessayer ultérieurement" }
        end
    end
end
