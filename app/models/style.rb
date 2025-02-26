class Style < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy

  def self.top(num)
    Style.all.sort_by(&:average_rating_for_style).reverse.first(num)
  end
end
