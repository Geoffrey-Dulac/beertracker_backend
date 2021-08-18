class BeersController < ApplicationController
    before_action :authorized

    # /beers_names
    def index_names
        beers_array = []
        Beer.all.each do |beer|
            beers_array << beer.name
        end
        render json: { beers: beers_array }
    end
end
