class BeersController < ApplicationController
    before_action :authorized

    # /beers
    def index
        beers_array = []
        user = User.find_by(id: decoded_token[0]['user_id'])
        Beer.all.order("grade DESC").each do |beer|
            data = {}
            userbeer = UserBeer.find_by(user: user, beer: beer)
            data['beer'] = beer
            data['brewer'] = beer.brewer
            if userbeer.present?
                data["user_grade"] = userbeer.user_grade
            else 
                data["user_grade"] = ''
            end
            beers_array << data
        end
        render json: { beers: beers_array }
    end

    # /beers_names
    def index_names
        beers_array = []
        Beer.all.each do |beer|
            beers_array << beer.name
        end
        render json: { beers: beers_array }
    end
end
