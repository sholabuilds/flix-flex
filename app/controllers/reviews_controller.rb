class ReviewsController < ApplicationController
    before_action :set_movie
    
    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(reviews_params)

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
        params.require(:review).permit(:name, :stars, :comment)
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end
end
