require 'bcrypt'

class AuthController < ApplicationController
    def login
        user = User.find_by(email: params[:email])
        if params[:email] === '' || params[:password] === ''
            render json: { status: 'failed', message: 'Tous les champs sont obligatoires' }
        elsif !user
            render json: { status: 'failed', message: "Cet utilisateur n'existe pas" }
        elsif user && BCrypt::Password.new(user.password) == params[:password]
            render json: { status: 'success' }
        elsif user
            render json: { status: 'failed', message: "Mot de passe invalide" }
        end
    end
end