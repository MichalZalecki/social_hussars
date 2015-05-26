Given(/^I'm on the homapage$/) do
  visit root_path
end

Then(/^I should see all questions$/) do
  expect(page).to have_selector('.question', count: Question.count)
  Question.all.each do |question|
    expect(page).to have_link(question.title)
  end
end
