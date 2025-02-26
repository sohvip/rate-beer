module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    ratings.inject(0) { |sum, r| sum + r.score.to_f } / ratings.size
  end
end
