class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
    # Confirms a logged in user:
    def check_loggedin
      unless loggedin?
        store_url
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end