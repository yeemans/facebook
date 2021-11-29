class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    helper_method :signed_in_user 
    def signed_in_user
      return current_user 
    end
end
