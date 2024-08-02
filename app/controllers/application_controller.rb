class ApplicationController < ActionController::Base
    helper_method :current_user, :current_user?, :current_user_admin?

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

    def require_admin
        unless current_user_admin?
            redirect_to root_url, status: :see_other, alert: "Unauthorized access"
        end
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user?(user)
        current_user == user
    end

    def current_user_admin?
        current_user && current_user.admin?
    end
end
