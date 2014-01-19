require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  context 'when created' do
    it 'should be able to have a name' do
      expect do
        Category.new.name = 'Foo'
      end.not_to raise_error
    end
  end
end
