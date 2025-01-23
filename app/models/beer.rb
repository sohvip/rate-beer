class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    beer_ratings = ratings.find_all { |rating| rating.beer_id == self.id }
    avg = beer_ratings.inject(0) { |sum, r| sum + r.score.to_f } / beer_ratings.size
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
