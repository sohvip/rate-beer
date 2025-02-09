require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "is" do
    let(:test_brewery) { Brewery.create name: "test", year: 2000 }

    it "saved with a proper name, style, and brewery" do
      beer = Beer.create name: "Olut", style: "Lager", brewery_id: test_brewery.id

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "not saved without a name" do
      beer = Beer.create style: "Lager", brewery_id: test_brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "not saved without a style" do
      beer = Beer.create name: "Olut", brewery_id: test_brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
