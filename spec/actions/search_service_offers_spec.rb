require File.dirname(__FILE__) + '/../spec_helper'

class SearchServiceOffers
  include LightService::Organizer
  def self.with_options(options = {})
    with(options).reduce [
      ValidateTimes,
      ValidateLength,
      ValidateLanguage,
      ValidateGroups
    ]
  end

  class ValidateTimes
    include LightService::Action
    executed do |context|
      times = context.fetch :times

      if times.empty?
        context.set_failure! 'No times given!'
      end
    end
  end

  class ValidateLength
    include LightService::Action
    executed do |context|
      begin
        context.fetch :length
      rescue KeyError
        context.set_failure! 'No length given!'
      end
    end
  end

  class ValidateLanguage
    include LightService::Action
    executed do |context|
      languages = context.fetch :languages
      if languages.empty?
        context.set_failure! 'No languages given!'
      end
    end
  end

  class ValidateGroups
    include LightService::Action
    executed do |context|
      groups = context.fetch :groups

      begin
        Group.find groups
      rescue => e
        context.set_failure! 'Group not found!'
        context[:error] = e
      end
    end
  end
end

describe SearchServiceOffers do
  before(:each) do
    User.delete_all
    Offer.delete_all
  end

  context 'for insufficient conditions' do
    it 'should do nothing without times given' do
      options = {
        times: []
      }

      result = SearchServiceOffers.with_options options
      expect(result.success?).to be_false
      expect(result.message).to eql('No times given!')
    end

    it 'should do nothing without a length given' do
      options = {
        times: [1, 2, 3, 4]
      }

      result = SearchServiceOffers.with_options options
      expect(result.success?).to be_false
      expect(result.message).to eql('No length given!')
    end

    it 'should do nothing without at least one language given' do
      options = {
        times: [1, 2, 3, 4],
        length: 30,
        languages: []
      }
      result = SearchServiceOffers.with_options options
      expect(result.success?).to be_false
      expect(result.message).to eql('No languages given!')
    end

    context 'without at least one valid group given' do
      before(:each) do
        Group.delete_all
      end

      it 'should fail with just a non existing group' do
        opts = options
        opts[:groups] << 'foo'
        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_false
        expect(result.message).to eql('Group not found!')
      end

      it 'should be okay with one existing group' do
        opts = options
        opts[:groups] << valid_id

        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_true
      end

      it 'should fail with at least only one existing group' do
        opts = options
        opts[:groups] << 'foo'
        opts[:groups] << valid_id
        opts[:groups] << 'bar'

        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_false
      end

      def valid_id
        g = Group.create name: 'Bingo tactics'
        g.id.to_s
      end

      def options
        {
          times: [1, 2, 3, 4],
          length: 30,
          languages: %W(english german),
          groups: []
        }
      end
    end
  end
end
