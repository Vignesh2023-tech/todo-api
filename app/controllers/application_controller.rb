class ApplicationController < ActionController::Base

  # before_action :authenticate_user, :only => [:index]

  private

  def authenticate_user
    unless cookies.signed[:user_token]
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # Here we write this function to check the user is logged in or not for all routes
  def authenticate
    begin
      puts "params #{params}"
      #It is a build in method, this takes callbacks as a argument
      authenticate_or_request_with_http_token do |token, options|
        puts "Authentication #{token}"
        verified_token = JWT.decode token, JWT_SECRET, true, {algorithm: "HS512"}
        user_id = verified_token[0]['sub']
        @current_user = User.find(user_id)
      end
    rescue
      render status: 401, json: {
        errors: [
          {
            status: 401,
            title: "Unauthorized"
          }
        ]
      }
    end
  end


end
