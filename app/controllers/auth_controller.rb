require 'bcrypt'

class AuthController < ApplicationController
    def login
        user = User.find_by(email: params[:email])
        if params[:email] === '' || params[:password] === ''
            render json: { status: 'failed', message: 'Tous les champs sont obligatoires' }
        elsif !user
            render json: { status: 'failed', message: "Cet utilisateur n'existe pas" }
        elsif user && BCrypt::Password.new(user.password) == params[:password]
            token = encode_token({user_id: user.id})
            render json: { status: 'success', token: token }
        elsif user
            render json: { status: 'failed', message: "Mot de passe invalide" }
        end
    end
end