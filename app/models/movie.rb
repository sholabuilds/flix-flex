class Movie < ApplicationRecord

    RATINGS = %w(G PG PG-13 R NC-17)

    validates :title, :release_date, :director, presence: true
    
    validates :description, length: { minimum: 25 }
    
    validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

    validates :rating, inclusion: {
        in: RATINGS,
            message: "%{value} is not a valid rating"
    }

    validates :image_file_name, format: {
        with: /\w+\.(jpg|png)\z/i,
        message: "must be a JPG or PNG image"
    }

    def self.previous_releases
        where("release_date < ?", Time.now).order("total_gross DESC")
    end

    def self.hit_releases
        where("total_gross > ?", 300000000).order("total_gross desc")
    end

    def self.flop_releases
        where("total_gross < ?", 225000000).order("total_gross asc")
    end

    def self.recent_releases
        find_by("created_at", 3).order("created_at desc")
    end

    def flop?
        total_gross.blank? || total_gross < 15000000
    end
end
