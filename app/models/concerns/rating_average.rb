module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    rating_count = ratings.size

    return 0 if rating_count == 0

    ratings.map(&:score).sum / rating_count
  end

  def average_rating_for_style
    return 0 if beers.empty?

    total_ratings = beers.map(&:ratings).flatten
    return 0 if total_ratings.empty?

    total_ratings.sum(&:score).to_f / total_ratings.size
  end
end
