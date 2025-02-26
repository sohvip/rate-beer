module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    ratings.inject(0) { |sum, r| sum + r.score.to_f } / ratings.size
  end

  def average_rating_for_style
    return 0 if beers.empty?

    total_ratings = beers.map(&:ratings).flatten
    return 0 if total_ratings.empty?

    total_ratings.sum(&:score).to_f / total_ratings.size
  end
end
