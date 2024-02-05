require 'jwt'
class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authenticate, only: [:showCurrentUser]

  def index
    @user = User.all;
    render json: {users: @user}
  end

  def create
    name = params[:user][:name]
    email = params[:user][:email]
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    begin
      @user = User.new(name: name, email: email, password: password, password_confirmation: password_confirmation)
      @user.save!
      render json: {users: @user}
    rescue => e
      render json: {errors: @user.errors},  status: 400
    end
  end

  def createSession
    email = params[:email]
    password = params[:password]

    begin
      @user = User.find_by!(email: email)

      if BCrypt::Password.new(@user.password_digest) == password
        data = @user
        payload = {data: data, sub: @user.id, exp: Time.now.to_i + 1 * 3600}

        token = JWT.encode payload, JWT_SECRET, 'HS512'
        render json: {token: token}

      else
        raise 'Invalid Email or Password'
      end
    rescue => e
      BCrypt::Password.create(password)
        render json: {errors: e},  status: 400

      # render :status => :unauthorized, json: {
      #   errors: [
      #     {
      #       status: 401,
      #       title: "Unauthorized",
      #       detail: "Invalid Email or Password"
      #     }
      #   ]
      # }
    end
  end

  def showCurrentUser
    # this action call the method in the application controller
    render json: {current_user: ActiveModel::SerializableResource.new(@current_user, serializer: UserSerializer)}
  end
end
