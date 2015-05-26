Given(/^a signed in user "(.*?)"$/) do |username|
  visit new_user_session_path
  user = User.find_by(username: username)
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'abc123456'
  click_button 'Sign in'
end
