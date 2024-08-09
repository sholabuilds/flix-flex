class RemoveSlugFromGenres < ActiveRecord::Migration[7.1]
  def change
    remove_column :genres, :slug, :string
  end
end
