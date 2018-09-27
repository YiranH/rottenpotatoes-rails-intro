class Movie < ActiveRecord::Base
    attr_accessible :title, :rating, :release_date
    # def self.all_ratings
    #     chosen = {}
    #     self.select(:rating).uniq.each do |movie|
    #         chosen[movie.rating] = 1
    #     end 
    #     return chosen
    # end 
    def self.all_ratings
        chosen = {}
        self.select('rating').uniq.each {|x| chosen.push(x.rating)}
        chosen.sort.uniq
        end
    end 
end
