class ApplicationController < ActionController::Base
    helper_method :current_user, :current_user?

    private
    def require_signin
        unless current_user
            flash[:error] = "Sign in is required"
            # stores intended url in session cookie
            # for redirecting to the intended url
            # when user correctly signs in 
            # (with the sessions controller)
            session[:intended_url] = request.url
            redirect_to signin_path
        end
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user?(user)
        current_user == user
    end
end
