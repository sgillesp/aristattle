class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    
    helper_method :current_user
    
    private
    
    def current_user
        # note needed to use $oid with session[:user_id] as mondoid workaround
        @current_user ||= User.find(session[:user_id]['$oid']) if session[:user_id]
    end
end
