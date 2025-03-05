class Beer < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def self.top(num)
    Beer.all.sort_by(&:average_rating).reverse.first(num)
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
