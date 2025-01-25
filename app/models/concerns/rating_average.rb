module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.inject(0) { |sum, r| sum + r.score.to_f } / ratings.size
  end
end
