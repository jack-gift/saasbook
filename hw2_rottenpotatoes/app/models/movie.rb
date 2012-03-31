class Movie < ActiveRecord::Base
  
#  include Comparable
#  def <=>(other)
#    self.release_date <=> other.release_date
#  end
  
  @@all_ratings = ['G', 'PG', 'PG-13', 'R']
  def self.all_ratings
    @@all_ratings
    
  end
end
