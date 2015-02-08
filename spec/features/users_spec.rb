require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      visit signin_path
      fill_in('username', with:'Pekka')
      fill_in('password', with:'wrong')
      click_button('Log in')

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end
end

  describe "users page" do
    let!(:user) { FactoryGirl.create :user}
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
    let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
    let!(:beer3) { FactoryGirl.create :beer, name:"testiolut", brewery:brewery }
    let!(:user2) { FactoryGirl.create :user , username: "testi"}

    before :each do
      sign_in(username:"Pekka", password:"Foobar1")
    end

    it "shows all self made ratings and not show other peoples ratings" do
      FactoryGirl.create :rating2, beer: beer1, user: user
      FactoryGirl.create :rating, beer: beer2, user: user
      FactoryGirl.create :rating, beer: beer3, user: user2
      visit user_path(user)

      expect(page).to have_content "Has made 2 ratings"
      expect(page).to have_content "iso 3 20"
      expect(page).to have_content "Karhu 10"
      expect(page).not_to have_content "testiolut 10"
    end

    it "removes own ratings" do
      FactoryGirl.create :rating, beer: beer1, user: user
      FactoryGirl.create :rating, beer: beer1, user: user
      FactoryGirl.create :rating2, beer: beer1, user: user
      visit  user_path(user)

      expect{
        page.first(:link, "delete").click
      }.to change{user.ratings.count}.from(3).to(2)
    end

    it "shows favorite style" do
      FactoryGirl.create :rating, score:1, beer: (FactoryGirl.create :beer, style: "Lager"), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, style: "Lager"), user:user
      FactoryGirl.create :rating, score:3, beer: (FactoryGirl.create :beer, style: "IPA"), user:user
      FactoryGirl.create :rating, score:4, beer: (FactoryGirl.create :beer, style: "IPA"), user:user
      FactoryGirl.create :rating, score:5, beer: (FactoryGirl.create :beer, style: "Porter"), user:user
      visit user_path(user)

      expect(page).to have_content "Favorite style Porter"
    end

    it "shows favorite brewery" do
      brewery2 = FactoryGirl.create :brewery, name:"testi"
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery), user:user
      FactoryGirl.create :rating, score:1, beer: (FactoryGirl.create :beer, brewery:brewery), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery2), user:user
      FactoryGirl.create :rating, score:2, beer: (FactoryGirl.create :beer, brewery:brewery2), user:user
      visit user_path(user)

      expect(page).to have_content "Favorite brewery testi"
    end
  end
