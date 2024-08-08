class ReviewsController < ApplicationController
    before_action :set_movie
    before_action :require_signin
    
    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(reviews_params)
        # associates the current signed in user to the review
        @review.user = current_user

        if @review.save
            redirect_to movie_reviews_url, notice: "Thanks for your review!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @review = @movie.reviews.find(params[:id])
    end

    def update
        @review = @movie.reviews.find(params[:id])

        if @review.update(reviews_params)
            redirect_to movie_reviews_url, notice: "Review successfully updated!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @review = @movie.reviews.find(params[:id])
        @review.destroy
        
        redirect_to movie_reviews_url, status: :see_other, alert: "Review successfully deleted"
    end

    private

    def reviews_params
        params.require(:review).permit(:stars, :comment)
    end

    def set_movie
      @movie = Movie.find_by(slug: params[:movie_id])
    end
end
