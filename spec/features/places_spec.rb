require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      {
        "location" => {
          "name" => "Kumpula",
        },
        "current" => {
          "temperature" => 0,
          "weather_icons" => ["http://url_to_icon.png"],
          "wind_speed" => 0,
          "wind_dir" => ["S"]
        }
      }
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "Gurula", id: 2 ), Place.new( name: "Iguana", id: 3 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      {
        "location" => {
          "name" => "Kumpula",
        },
        "current" => {
          "temperature" => 0,
          "weather_icons" => ["http://url_to_icon.png"],
          "wind_speed" => 0,
          "wind_dir" => ["S"]
        }
      }
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Gurula"
    expect(page).to have_content "Iguana"
  end

  it "if none is returned by the API, page tells that no locations were found" do
    allow(BeermappingApi).to receive(:places_in).with("vallila").and_return(
      []
    )
    allow(WeatherApi).to receive(:weather_in).with("vallila").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'vallila')
    click_button "Search"

    expect(page).to have_content "No locations in vallila"
  end
end
