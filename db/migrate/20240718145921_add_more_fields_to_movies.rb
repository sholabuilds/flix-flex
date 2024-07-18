class AddMoreFieldsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :director, :string
    add_column :movies, :duration, :string, default: 0
    add_column :movies, :image_file_name, :string, default: "placeholder.png" 
  end
end
