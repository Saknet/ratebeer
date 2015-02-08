require 'rails_helper'

describe "Beer" do

  let!(:user){ FactoryGirl.create :user }
  let!(:brewery){ FactoryGirl.create :brewery }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "with valid name is saved" do
    visit new_beer_path

    fill_in('beer[name]', with: 'iso 3')
    select('Lager', from: 'beer[style]')
    select('anonymous', from: 'beer[brewery_id]')

    expect{
      click_button("Create Beer")
    }.to change{Beer.count}.from(0).to(1)
  end

  it "with invalid name is not saved" do
    visit new_beer_path
    fill_in('beer[name]', with: "")
    select('Lager', from: 'beer[style]')
    select('anonymous', from: 'beer[brewery_id]')

    expect{
      click_button("Create Beer")
    }.not_to change{Beer.count}
  end
end