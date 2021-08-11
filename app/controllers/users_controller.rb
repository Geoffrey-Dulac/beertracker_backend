class UsersController < ApplicationController
    def create
        user = User.create(user_params)
        raise
        if user.valid?
            payload = {user_id: user.id}
            token = encode_token(payload)
            render json: {user: user, jwt: token }
        else 
            render json: {errors: user.errors.full_messages }, statuts: :not_acceptable
        end
    end

    private

    def user_params
        params.permit(:user_name, :password, :email)
    end
end
