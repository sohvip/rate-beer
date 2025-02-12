require "rails_helper"

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("Iso 3", from: "rating[beer_id]")
    fill_in("rating[score]", with: "15")

    expect{
      click_button("Create Rating")
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is shown properly on the page" do
    FactoryBot.create :rating, beer: beer1, user: user
    FactoryBot.create :rating, beer: beer2, user: user

    visit ratings_path

    expect(page).to have_content "Number of ratings: 2"
    expect(page).to have_content "Iso 3: 10"
    expect(page).to have_content "Karhu: 10"
  end

  it "is shown on the user's page" do
    FactoryBot.create :rating, beer: beer1, user: user
    user2 = FactoryBot.create :user, username: "Mikko", password: "Moobar1", password_confirmation: "Moobar1"
    FactoryBot.create :rating, beer: beer2, user: user2

    visit user_path(user)

    expect(page).not_to have_content "Karhu 10"
    expect(page).to have_content "Iso 3 10"
    expect(Rating.count).to eq(2)
  end

  it "is deleted from the database when user deletes it" do
    FactoryBot.create :rating, beer: beer1, user: user
    FactoryBot.create :rating, beer: beer2, user: user

    visit user_path(user)

    find(:xpath, "(//a[text()='Delete'])[2]").click
    expect(page).not_to have_content "Karhu 10"
    expect(page).to have_content "Iso 3 10"
    expect(Rating.count).to eq(1)
  end
end
