require 'rails_helper'

describe Beer do

  describe "with proper name and style" do

    it "it is saved" do
      beer = Beer.create name:"testiolut", style:"Lager"
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "with no name" do

    it "it is not saved" do
      beer = Beer.create
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "with no style" do

    it "it is not saved" do
      beer = Beer.create name:"testiolut2"
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "when one beer exists" do
    let(:beer){FactoryGirl.create(:beer)}

    it "is valid" do
      expect(beer).to be_valid
    end

    it "hs the default style" do
      expect(beer.style).to eq("Lager")
    end
  end
end