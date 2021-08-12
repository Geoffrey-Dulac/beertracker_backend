require 'bcrypt'

class AuthController < ApplicationController
    # /users
    def login
        user = User.find_by(email: params[:email])
        if user && BCrypt::Password.new(user.password) == params[:password]
            token = encode_token({user_id: user.id, user_username: user.username})
            render json: { status: 'success', token: token }
        else
            render json: { status: 'failed', message: 'Login failed ! email or password invalid' }
        end
    end
end