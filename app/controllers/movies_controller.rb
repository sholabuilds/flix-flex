class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    case(params[:filter])
    when "upcoming_releases"
      @movies = Movie.upcoming_releases
    when "recent_releases" 
      @movies = Movie.recent
    when "hits"
      @movies = Movie.hits
    when "flops"
      @movies = Movie.flops
    else
      @movies = Movie.previous_releases
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movies_params)

    if @movie.save
      redirect_to @movie, notice: "Movie successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)

    if current_user
      @favourite = current_user.favourites.find_by(movie_id: @movie.id)
    end
  end

  def edit
  end

  def update
    if @movie.update(movies_params)
      redirect_to @movie, notice: "Movie successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, status: :see_other, alert: "Movie successfully deleted"
  end

  private

  def movies_params
     # the :movie sym is derived from the key name in the request params
    params.require(:movie).permit(:title, :description, :rating, :total_gross, :release_date, :director, :duration, :main_image, genre_ids: [])
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end
end
