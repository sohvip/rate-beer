require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  describe "is not saved" do

    it "without a password" do
      user = User.create username: "Pekka"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with a password that is fewer than 4 characters" do
      user = User.create username: "Pekka", password: "Mo1", password_confirmation: "Mo1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with a password that is all lowercase" do
      user = User.create username: "Pekka", password: "pieni", password_confirmation: "pieni"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create :user }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create :rating, score: 10, user: user
      FactoryBot.create :rating, score: 20, user: user

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create :user }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create :beer
      rating = FactoryBot.create :rating, score: 20, beer: beer, user: user

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create :user }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = FactoryBot.create :beer
      FactoryBot.create :rating, score: 20, beer: beer, user: user

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest average rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      beer = FactoryBot.create :beer, name: "Kalja", style: "IPA"
      create_beers_with_many_ratings({ user: user }, *[20, 30, 40], beer: beer)
      beer2 = FactoryBot.create :beer, name: "Olut"
      create_beers_with_many_ratings({ user: user }, *[10, 20, 15, 7, 9], beer: beer2)

      expect(user.favorite_style).to eq(beer.style)
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create :user }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
      brewery = FactoryBot.create :brewery
      beer = FactoryBot.create :beer, brewery: brewery
      FactoryBot.create :rating, score: 20, beer: beer, user: user

      expect(user.favorite_brewery).to eq(brewery.name)
    end

    it "is the brewery with highest average rating if several rated" do
      brewery = FactoryBot.create :brewery
      beer = FactoryBot.create :beer, name: "Kalja", style: "IPA", brewery: brewery
      create_beers_with_many_ratings({ user: user }, *[20, 30, 29], beer: beer)
      beer2 = FactoryBot.create :beer, name: "Olut", brewery: brewery
      create_beers_with_many_ratings({ user: user }, *[10, 20, 15, 7, 9], beer: beer2)
      brewery2 = FactoryBot.create :brewery, name: "Panimo"
      beer3 = FactoryBot.create :beer, brewery: brewery2
      create_beers_with_many_ratings({ user: user }, *[20, 30, 40], beer: beer3)

      expect(user.favorite_brewery).to eq(brewery2.name)
    end
  end
end
