require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "User is not saved" do

    it "if password is too short" do
      user1 = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"
      expect(user1).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "if password only contains letters" do
      user2 = User.create username:"Pekka", password:"sEcret", password_confirmation:"sEcret"
      expect(user2).not_to be_valid
      expect(User.count).to eq(0)
    end
  end


  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating if several styles are rated" do
      FactoryGirl.create :rating, score:1, beer: (FactoryGirl.create :beer, style: "Lager"), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, style: "Lager"), user:user
      FactoryGirl.create :rating, score:3, beer: (FactoryGirl.create :beer, style: "IPA"), user:user
      FactoryGirl.create :rating, score:4, beer: (FactoryGirl.create :beer, style: "IPA"), user:user
      FactoryGirl.create :rating, score:5, beer: (FactoryGirl.create :beer, style: "Porter"), user:user

      expect(user.favorite_style).to eq("Porter")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only beers from 1 brewery have ratings" do
      brewery = FactoryGirl.create :brewery, name:"Koff"
      FactoryGirl.create :rating, score:1, beer: (FactoryGirl.create :beer, brewery:brewery), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery), user:user

      expect(user.favorite_brewery).to eq(brewery.name)
    end

    it "is the one with highest average rating if several beers from breweries have been" do
      brewery = FactoryGirl.create :brewery, name:"Koff"
      brewery2 = FactoryGirl.create :brewery, name:"testi"
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery), user:user
      FactoryGirl.create :rating, score:1, beer: (FactoryGirl.create :beer, brewery:brewery), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery2), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery2), user:user

      expect(user.favorite_brewery).to eq(brewery2.name)
    end
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end
end

