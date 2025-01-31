class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }
  validate :less_than_or_equal_to_current_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2025
    puts "changed year to #{year}"
  end

  def less_than_or_equal_to_current_year
    return unless year > Time.now.year

    errors.add(:year, "can't be greater than current year")
  end
end
