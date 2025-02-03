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
end
