# encoding: utf-8
require 'spec_helper'

describe User do
  it 'has a name' do
    expect do
      User.new name: 'Florian'
    end.to_not raise_error
  end
end
