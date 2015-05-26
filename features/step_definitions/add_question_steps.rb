Given(/^I'm on ask question page$/) do
  visit new_question_path
end

When(/^I fill title "(.*?)" and contents "(.*?)"$/) do |title, contents|
  fill_in 'Title', with: title
  fill_in 'Contents', with: contents
  click_button 'Create Question'
end

Then(/^see the "(.*?)" alert with "(.*?)"$/) do |type, msg|
  expect(find(".alert-#{type}")).to have_content(msg)
end

Then(/^answer with title "(.*?)" and contents "(.*?)"$/) do |title, contents|
  within '.question' do
    expect(find('h3')).to have_content(title)
    expect(find('p')).to have_content(contents)
  end
end
