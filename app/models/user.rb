class User < ApplicationRecord
  before_save :format_username
  before_save :format_email
  before_save :set_slug

  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_movies, through: :favourites, source: :movie

  scope :by_name, -> { all.order("name asc") }
  scope :non_admin, -> { by_name.where(admin: false) }

  validates :name, presence: true

  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 10, allow_blank: true }

  validates :username, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    slug
  end

  private

  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end

  def set_slug
    self.slug = username.parameterize
  end
end
