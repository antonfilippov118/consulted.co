require 'spec_helper'

describe TogglesUserExpert do
  before(:each) do
    User.delete_all
  end
  subject(:action) { TogglesUserExpert }
  it 'should turn a normal user into an expert' do
    user = User.create valid_params
    user.confirm!
    result = action.for user
    expect(result.success?).to be_true
    expect(User.first.wants_to_be_an_expert?).to be_true
  end

  it 'should turn an expert back into a normal user' do
    user = User.create valid_params.merge wants_to_be_an_expert: true
    user.confirm!
    result = action.for user
    expect(result.success?).to be_true
    expect(User.first.wants_to_be_an_expert?).to be_false
  end
end
