require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  it 'should have a name' do
    expect do
      Group.new.name = 'Foo'
    end.not_to raise_error
  end

  it do
    should embed_many :categories
  end
end
