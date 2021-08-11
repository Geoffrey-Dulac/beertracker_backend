require 'bcrypt'
class UsersController < ApplicationController
    def create
        user = User.new(user_params)
        user.password = BCrypt::Password.create(params[:password])
        user.save
        if user.valid?
            render json: { user: user }
        else 
            render json: { errors: user.errors.full_messages }, statuts: :not_acceptable
        end
    end

    private

    def user_params
        params.permit(:username, :email)
    end
end
