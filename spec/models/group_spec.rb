require File.dirname(__FILE__) + '/../spec_helper'

describe Group do

  before(:all) do
    Group.delete_all
    Category.delete_all
  end

  it 'should have a name' do
    expect do
      Group.new.name = 'Foo'
    end.not_to raise_error
  end

  it do
    should embed_many :categories
  end

  it 'should be createable with categories' do
    group = Group.new name: 'Foo'

    group.categories << Category.new(name: 'Bar')

    expect do
      group.save!
    end.not_to raise_error

    expect(Group.count).to eql(1)
  end
end
