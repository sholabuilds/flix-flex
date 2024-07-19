class MoviesController < ApplicationController
  def index
    @movies = Movie.previous_releases
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update(movies_params)
      redirect_to @movie, notice: "Movie successfully updated"
    else
      render :edit, status: :unprocessable_entity
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

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, status: :see_other, alert: "Movie successfully deleted"
  end

  private

  def movies_params
     # the :movie sym is derived from the key name in the request params
    params.require(:movie).permit(:title, :description, :rating, :total_gross, :release_date, :director, :duration, :image_file_name)
  end
end
