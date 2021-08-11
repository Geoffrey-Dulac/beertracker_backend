require 'bcrypt'
class UsersController < ApplicationController
    def create
        user = User.new(user_params)
        user.password = BCrypt::Password.create(params[:password])
        user.save
        if user.valid?
            render json: { status: 'success' }
        elsif params[:email] === '' || params[:password] === '' || params[:username] === ''
            render json: { status: 'failed', message: 'Tous les champs sont obligatoires' }   
        else
            render json: { status: 'failed', message: 'Veuillez vérifier tous les champs' }
        end
    end

    private

    def user_params
        params.permit(:username, :email)
    end
end
