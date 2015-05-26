Given(/^I am on the leaderboard page$/) do
  visit page_leaderboard_path
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(find('.container')).to have_content('Leaderboard')
end
