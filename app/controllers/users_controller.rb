class UsersController < ApplicationController
    before_action :require_signin, except: [:new, :create]
    before_action :require_correct_user, only: [:edit, :update, :destroy]

    def index
        @users = User.non_admin
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            redirect_to @user, notice: "Thanks for signing up"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find_by(slug: params[:id])
        @reviews = @user.reviews
        @favourite_movies = @user.favourite_movies
    end

    def edit
    end

    def update
        if @user.update(user_params)
            redirect_to @user, notice: "Profile successfully updated"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil
        
        redirect_to users_url, status: :see_other, alert: "User profile deleted"
    end
    
    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :username)
    end

    def require_correct_user
        # since this method runs before its' associated methods
        # the user instance variable becomes available 
        # in the methods
        @user = User.find(params[:id])
        unless current_user?(@user) 
            redirect_to root_url, status: :see_other
        end
    end
end
