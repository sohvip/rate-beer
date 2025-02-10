require "rails_helper"

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

  before :each do
    visit beers_path
  end

  it "is created with a valid name" do
    click_link("New beer")
    fill_in("beer_name", with: "Karhu")

    expect{
      click_button("Create Beer")
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not created without a name" do
    click_link("New beer")
    click_button("Create Beer")

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end