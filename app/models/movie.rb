class Movie < ActiveRecord::Base

def self.all_ratings
	select(:rating).map(&:rating).uniq
end	

end
