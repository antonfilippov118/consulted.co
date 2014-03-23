step 'I exist as admin' do
  @current_admin = create :admin
end

step 'I exist as user' do
  @current_user = create :user, :confirmed
end

step 'I am signed in as admin' do
  step 'I exist as admin'
  sign_in_as @current_admin
end

step 'I am signed in as user' do
  step 'I exist as user'
  sign_in_as @current_user
end
