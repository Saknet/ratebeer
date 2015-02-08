class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15}

  validates :password, format: { with: /(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{4,}/,
                                message: "must be atleast 4 chars long and must contain atleast 1 number and 1 uppercase letter"}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships, dependent: :destroy

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

end
