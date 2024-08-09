class Movie < ApplicationRecord
    before_save :set_slug

    has_many :reviews, dependent: :destroy
    has_many :critics, through: :reviews, source: :user

    has_many :favourites, dependent: :destroy
    has_many :fans, through: :favourites, source: :user

    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    has_one_attached :main_image

    RATINGS = %w(G PG PG-13 R NC-17)

    validates :title, presence: true, uniqueness: true
    
    validates :release_date, :director, presence: true
    
    validates :description, length: { minimum: 25 }
    
    validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

    validates :rating, inclusion: {
        in: RATINGS,
            message: "%{value} is not a valid rating"
    }

    validate :acceptable_image

    scope :previous_releases, -> { where("release_date < ?", Time.now).order("total_gross DESC") }

    scope :upcoming_releases, -> { where("release_date > ?", Time.now).order("total_gross DESC") }

    scope :recent, ->(max=5) { previous_releases.limit(max) }

    scope :hits, -> { previous_releases.where("total_gross > ?", 300000000).order("total_gross desc") }

    scope :flops, -> { previous_releases.where("total_gross < ?", 225000000).order("total_gross asc") }

    scope :grossed_less_than, ->(amount) { previous_releases.where("total_gross < ?", amount) }

    scope :grossed_greater_than, ->(amount) { previous_releases.where("total_gross > ?", amount) }

    def self.recent_releases
        find_by("created_at", 3).order("created_at desc")
    end

    def flop?
        unless (reviews.count > 50 && average_stars >= 4)
            total_gross.blank? || total_gross < 225000000
        end
    end

    def average_stars
        reviews.average(:stars) || 0.0
    end

    def average_stars_as_percent
        (self.average_stars / 5.0) * 100.0
    end

    def to_param
        slug
    end

    private

    def set_slug
        self.slug = title.parameterize
    end

    def acceptable_image
        return unless main_image.attached?
      
        unless main_image.blob.byte_size <= 1.megabyte
          errors.add(:main_image, "is too big")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(main_image.blob.content_type)
          errors.add(:main_image, "must be a JPEG or PNG")
        end
    end
end
