def sign_in_as_admin(admin)
  visit new_admin_session_path

  fill_in 'admin_email', with: admin.email
  fill_in 'admin_password', with: admin.password

  click_button 'Sign in'
end

def sign_in_as(resource)
  func = "sign_in_as_#{resource.class.to_s.downcase}"

  send(func.to_sym, resource)
end

step 'I sign in as admin with valid credentials' do
  sign_in_as @current_admin
end

step 'I sign in as admin with invalid credentials' do
  fake_admin = build(:admin, email: 'empty@email.com', password: 'empty password')
  sign_in_as fake_admin
end

# TODO: move such steps to separate file(e.g. web_steps)
step 'I should be on admin page' do
  current_path.should eq(rails_admin_path)
end

step 'I should be on home page' do
  current_path.should eq(root_path)
end

step 'I should be on admin sign in page' do
  current_path.should eq(new_admin_session_path)
end

step 'I sign out as admin' do
  within '.top-bar' do
    click_link 'Sign out'
  end
end
