class MoviesController < ApplicationController
  def index
    @movies = ["Supacell", "Insecure", "Snowfall", "Ones to Watch"]
  end
end
