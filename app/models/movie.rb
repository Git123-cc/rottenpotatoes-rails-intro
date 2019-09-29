class Movie < ActiveRecord::Base
    def self.ratings
        Moving.select(:rating).distinct.inject([]) { |a, m| a.push m.rating}
    end
end
