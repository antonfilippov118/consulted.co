require 'spec_helper'

describe FindsGroup do
  subject(:find_action) { FindsGroup }
  it 'should match a group by it\'s title' do
    Group.create name: 'Finance Bingo'

    result = find_action.for 'bingo'

    expect(result.success?).to be_true
    groups = result.fetch :groups
    expect(groups).to be_a Array
    expect(groups.length).to eql 1
  end

  it 'should match a group by it\'s description' do
    Group.create name: 'Foo', description: 'bingo'
    result = find_action.for 'bingo'
    expect(result.success?).to be_true
    groups = result.fetch :groups
    expect(groups.length).to eql 1
  end

  it 'should include groups only once' do
    Group.create name: 'bingo', description: 'straategies for bingo'
    result = find_action.for 'bingo'
    expect(result.success?).to be_true
    groups = result.fetch :groups
    expect(groups.length).to eql 1
  end

  it 'should only show groups with no children' do
    group = Group.create name: 'bingo'
    group.children.create name: 'foo'

    result = find_action.for 'bingo'
    expect(result.success?).to be_true
    groups = result.fetch :groups
    expect(groups.length).to eql 0
  end

  it 'should match groups by tag' do
    Group.create name: 'Foo', tag_array: %w(foo bar)
    result =  find_action.for 'bar'
    expect(result.success?).to be_true

    groups = result.fetch :groups
    expect(groups.first.name).to eql 'Foo'
  end
end
