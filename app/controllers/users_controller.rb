require 'bcrypt'
class UsersController < ApplicationController
    def create
        user = User.new(user_params)
        user.password = BCrypt::Password.create(params[:password])
        user.save
        if user.valid?
            token = encode_token({user_id: user.id, user_username: user.username})
            render json: { status: 'success', token: token }
        else
            render json: { status: 'failed', message: user.errors.full_messages }
        end
    end

    private

    def user_params
        params.permit(:username, :email)
    end
end
