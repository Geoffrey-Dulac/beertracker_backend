require 'bcrypt'

class ApplicationController < ActionController::API
    before_action :set_secret_password

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

    def encode_token(payload)
        JWT.encode(payload, @secret_pasword, 'HS256')
    end

    def auth_header
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, @secret_pasword, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def logged_in_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end
    
    def logged_in?
        !!logged_in_user
    end
    
    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

    private 

    def set_secret_password
        @secret_pasword = 'cr$Pt33'
    end
end
