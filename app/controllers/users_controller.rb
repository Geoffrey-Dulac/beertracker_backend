class UsersController < ApplicationController
    def create
        user = User.create(user_params)
        if user.valid?
            render json: {user: user }
        else 
            render json: {errors: user.errors.full_messages }, statuts: :not_acceptable
        end
    end

    private

    def user_params
        params.permit(:username, :password_digest, :email)
    end
end
