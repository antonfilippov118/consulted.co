step 'I go to login page' do
  visit new_user_session_path
end

step 'I go to forgot password page' do
  visit new_user_password_path
end

step 'I submit login form with valid credentials' do
  fill_in 'user_email', with: @current_user.email
  fill_in 'user_password', with: @current_user.password

  click_button 'Login'
end

step 'I should be logged in' do
  page.should have_content('Signed in successfully')
end

step 'I request new password' do
  fill_in 'Email', with: @current_user.email
  click_button 'Send me reset password instructions'
end

step 'I should receive reset password instructions email' do
  open_email(@current_user.email)

  expect(current_email).to have_subject 'Reset password instructions'
  expect(current_email.default_part_body.to_s).to match(/#{@current_user.email}/)
end

step 'I go to restore password page' do
  click_first_link_in_email
end

step 'I submit restore password form with my new password' do
  fill_in 'New password', with: 'new_password'
  fill_in 'Confirm new password', with: 'new_password'
  click_button 'Change my password'
end

step 'I should be logged in from restore password page' do
  page.should have_content('Your password was changed successfully. You are now signed in.')
end
