# Add a declarative step here for populating the DB with movies.

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(
      title: movie['title'],
      rating: movie['rating'],
      release_date: Date.parse(movie['release_date'])
    )
  end
end

Then(/(.*) seed movies should exist/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  pending "Fill in this step in movie_steps.rb"
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I check only the following ratings: PG, G, R"

When(/I check the following ratings: (.*)/) do |rating_list|
  ratings_to_check = rating_list.split(',').map(&:strip)
  Movie.all_ratings.each do |rating|
    if ratings_to_check.include?(rating)
      step %{I check "#{rating}"}
    else
      step %{I uncheck "#{rating}"}
    end
  end
end

Then(/^I should (not )?see the following movies: (.*)$/) do |no, movie_list|
  movie_list.split(',').map(&:strip).each do |title|
    if no
      step %{I should not see "#{title}"}
    else
      step %{I should see "#{title}"}
    end
  end
end

Then(/^I should see all the movies$/) do
  expect(page).to have_css('a', text: 'Show this movie', count: Movie.count)
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use this to write "Then debug" in your scenario to open a console.
  require "byebug"
  byebug
  1 # intentionally force debugger context in this method
end

Then(/^debug javascript$/) do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  raise "Remove this step from your .feature files"
end
