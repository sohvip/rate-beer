class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*\d)(?=.*[A-Z])/,
                                 message: "must contain at least one digit and one upper case letter!" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.map(&:beer).group_by(&:style)

    style_averages = styles.transform_values do |beers|
      beers.map(&:average_rating).sum / beers.size.to_f
    end

    style_averages.max_by { |_, avg| avg }&.first.name
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = ratings.map(&:beer).group_by(&:brewery)

    # Calculate average rating per style
    brewery_averages = breweries.transform_values do |beers|
      beers.map(&:average_rating).sum / beers.size.to_f
    end

    # Return the style with the highest average rating
    brewery_averages.max_by { |_, avg| avg }&.first&.name
  end
end
