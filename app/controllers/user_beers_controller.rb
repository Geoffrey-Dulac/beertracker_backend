class UserBeersController < ApplicationController
    before_action :authorized

    # /user_beers
    def index
        user = User.find_by(id: decoded_token[0]['user_id'])
        user_beers_array = []
        UserBeer.where(user: user).order("user_grade DESC").each do |user_beer|
            data = {}
            data["user_grade"] = user_beer.user_grade
            data["brewer"] = user_beer.beer.brewer
            data["beer"] = user_beer.beer
            user_beers_array << data
        end
        render json: { user_beers: user_beers_array, username: user.username }
    end

    # /create_user_beer
    def create
        beer = Beer.find_by(name: params[:name])
        userbeer = UserBeer.find_or_initialize_by(beer: beer)
        userbeer.user = User.find_by(id: decoded_token[0]['user_id'])
        userbeer.beer = beer
        userbeer.user_grade = params[:user_grade]
        if userbeer.save!
            render json: { status: 'success' }
        else 
            render json: { status: 'failed', message: "Impossible d'ajouter cette bière, merci de réessayer ultérieurement" }
        end
    end

    # /edit_or_create_usergrade
    def edit_or_create
        user = User.find_by(id: decoded_token[0]['user_id'])
        beer = Beer.find_by(name: params[:beername])
        usergrade = params[:user_grade]
        userbeer = UserBeer.find_or_initialize_by(beer: beer, user: user)
        userbeer.user_grade = usergrade
        if userbeer.save!
            render json: { status: 'success' }
        else 
            render json: { status: 'failed', message: "Impossible de noter cette bière, merci de réessayer ultérieurement" }
        end
    end
end
