class AuthController < ApplicationController
    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            payload = {user_id: user.id}
            token = encode_token(payload)
            render json: {user: user, jwt: token, success: "Bienvenue #{user.username}"}
        else
            render json: {failure: 'Mail et/ou mot de passe invalide'}
        end
    end
end