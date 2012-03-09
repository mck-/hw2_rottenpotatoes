class Movie < ActiveRecord::Base
  def self.get_ratings
    Movie.all.collect{|x| x.rating}.uniq
  end
end
