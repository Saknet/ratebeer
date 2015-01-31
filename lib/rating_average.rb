module RatingAverage
  def average_rating
    self.ratings.inject(0) {|sum, n| sum + n.score} / self.ratings.count
  end
end