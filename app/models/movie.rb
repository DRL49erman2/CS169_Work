class Movie < ApplicationRecord
  def self.all_ratings
    Movie.distinct.pluck(:rating).sort
  end

  def self.with_ratings(ratings_list)
    if ratings_list.present?
      where('rating IN (?)', ratings_list)
    else
      all
    end
  end
end