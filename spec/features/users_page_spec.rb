require "rails_helper"

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content "Welcome back!"
      expect(page).to have_content "Pekka"
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "Username and/or password mismatch"
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in("user_username", with: "Brian")
    fill_in("user_password", with: "Secret55")
    fill_in("user_password_confirmation", with: "Secret55")

    expect{
      click_button("Create User")
    }.to change{User.count}.by(1)
  end

  describe "favorite style and brewery" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
    end

    it "are not shown without any ratings" do
      expect(page).to have_content "No favorite style yet"
      expect(page).to have_content "No favorite brewery yet"
    end

    it "are shown if ratings exist" do
      brewery = FactoryBot.create :brewery
      beer = FactoryBot.create :beer, name: "Kalja", style: "IPA", brewery: brewery
      FactoryBot.create :rating, beer: beer, user: @user

      visit user_path(@user)

      expect(page).to have_content beer.style
      expect(page).to have_content brewery.name
    end
  end
end