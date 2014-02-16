require File.dirname(__FILE__) + '/../spec_helper'

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

  context 'searching for offers' do
    context 'prefetching appropiate languages' do
      before(:each) do
        create_expert languages: %W(german english), email: 'f@k.co'
        create_expert languages: %W(german), email: 's@k.co'
        create_expert languages: %W(german mandarin), email: 'a@k.co'
        create_group name: 'Byzantine Recklessness'
      end

      it 'should prefetch experts by languages' do
        opts = options
        opts[:languages] = %W(mandarin)
        result = SearchServiceOffers.with_options opts
        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(1), 'expected a mandarin expert'

        opts[:languages] = %W(english)
        result = SearchServiceOffers.with_options opts
        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(1), 'expected one english expert'

        opts[:languages] = %W(german)
        result = SearchServiceOffers.with_options opts
        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(3), 'expected three german experts'
      end
    end

    def options
      {
        groups: [Group.first.id.to_s],
        length: 30,
        times: [1, 2, 3, 4]
      }
    end

    def create_expert(opts)
      opts = valid_params.merge opts
      opts[:linkedin_network] = 10_000_000
      User.create! opts
    end

    def create_group(opts)
      opts = {
        name: 'Foo'
      }.merge opts

      Group.create opts
    end
  end
end
