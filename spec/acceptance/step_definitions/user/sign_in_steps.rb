step 'I go to login page' do
  visit new_user_session_path
end

step 'I submit login form with valid credentials' do
  fill_in 'user_email', with: @current_user.email
  fill_in 'user_password', with: @current_user.password

  click_button 'Login'
end

step 'I should be logged in' do
  page.should have_content('Signed in successfully')
end
