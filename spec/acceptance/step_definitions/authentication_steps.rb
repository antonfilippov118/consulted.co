step 'I exist as admin' do
  @current_admin = create :admin
end

step 'I am signed in as admin' do
  @current_admin = create :admin
  sign_in_as @current_admin
end
