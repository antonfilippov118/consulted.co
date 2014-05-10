step 'I am on registration page' do
  visit new_user_registration_path
end

step 'I submit registration form with required fields' do
  page.find('.toggle_login').trigger('click')
  fill_in 'user[email]', with: 'user@example.com'
  click_button 'Complete signup'
end

step 'I should receive registration confirmation email' do
  open_email 'user@example.com'
  current_email.should have_subject(/Your consulted.co profile activation/)
end

step 'I go to confirmation page' do
  click_first_link_in_email
end

step 'I submit confirmation form with required fields' do
  fill_in 'user[name]', with: 'Firstname Lastname'
  fill_in 'user[password]', with: '123456'
  fill_in 'user[password_confirmation]', with: '123456'
  click_button 'Confirm Account'
end

step 'I should be logged in from confirmation' do
  page.should have_content('Your account was successfully confirmed')
end
