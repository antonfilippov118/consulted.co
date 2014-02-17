require File.dirname(__FILE__) + '/../spec_helper'

describe SearchServiceOffers do
  before(:each) do
    User.delete_all
    Offer.delete_all
    Availability.delete_all
    Group.delete_all
  end

  context 'for insufficient conditions' do
    it 'should do nothing without times given' do
      options = {
        'times' => []
      }

      result = SearchServiceOffers.with_options options
      expect(result.success?).to be_false
      expect(result.message).to eql('No times given!')
    end

    it 'should do nothing without a length given' do
      options = {
        'times' => [1, 2, 3, 4]
      }

      result = SearchServiceOffers.with_options options
      expect(result.success?).to be_false
      expect(result.message).to eql('No length given!')
    end

    it 'should do nothing without at least one language given' do
      options = {
        'times' => [1, 2, 3, 4],
        'length' => 30,
        'languages' => []
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
        opts['groups'] << 'foo'
        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_false
        expect(result.message).to eql('Group not found!')
      end

      it 'should be okay with one existing group' do
        opts = options
        opts['groups'] << valid_id

        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_true
      end

      it 'should fail with at least only one existing group' do
        opts = options
        opts['groups'] << 'foo'
        opts['groups'] << valid_id
        opts['groups'] << 'bar'

        result = SearchServiceOffers.with_options opts
        expect(result.success?).to be_false
      end

      def valid_id
        g = Group.create name: 'Bingo tactics'
        g.id.to_s
      end

      def options
        {
          'times' => [{
            'ends' => '2014-02-20T00:45:21.012Z',
            'starts' => '2014-02-19T23:45:21.012Z'
          }],
          'length' => 30,
          'languages' => %W(english german),
          'groups' => []
        }
      end
    end
  end

  context 'with sufficient conditions' do
    context 'prefetching appropiate languages' do
      before(:each) do
        create_expert languages: %W(german english), email: 'f@k.co'
        create_expert languages: %W(german), email: 's@k.co'
        create_expert languages: %W(german mandarin), email: 'a@k.co'
        create_group name: 'Byzantine Recklessness'
      end

      it 'should prefetch experts by languages' do
        opts = options
        opts['languages'] = %W(mandarin)

        result = SearchServiceOffers.with_options opts

        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(1), 'expected a mandarin expert'

        opts['languages'] = %W(english)
        result = SearchServiceOffers.with_options opts
        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(1), 'expected one english expert'

        opts['languages'] = %W(german)
        result = SearchServiceOffers.with_options opts
        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(3), 'expected three german experts'
      end

      it 'should require all languages given to identify experts' do
        opts = options
        opts['languages'] = %W(english german)
        result = SearchServiceOffers.with_options opts

        expect(result[:experts]).not_to be_nil
        expect(result[:experts].length).to eql(1)
      end
    end

    context 'when finding appropiate groups' do
      before(:each) do
        create_expert languages: %W(german english), email: 'f@k.co'
        create_expert languages: %W(german), email: 's@k.co'
        create_expert languages: %W(german mandarin), email: 'a@k.co'

        create_group name: 'Byzantine Recklessness'
        create_group name: 'Bingo BS'
        create_group name: 'Stratagems'

        users  = User.all.to_a
        groups = Group.all.to_a

        create_availability
        create_availability user: users[1]
        create_availability user: users[2]

        create_offer group: groups[1]
        create_offer user: users[1], lengths: %W(30 45 120), group: groups[0]
        create_offer user: users[2], experience: 10, group: groups[2]
      end

      it 'should filter out any experts which do not match the groups selected' do
        opts = options
        result = SearchServiceOffers.with_options opts
        possible_offers = result.fetch :offers
        expect(possible_offers.length).to eql(1)

        opts['languages'] =  %W(english)
        opts['length'] = '90'
        opts['groups'] = [Group.all.to_a[1].id.to_s]

        result = SearchServiceOffers.with_options opts
        possible_offers = result.fetch :offers
        expect(possible_offers.length).to eql(1)

        opts['languages'] =  %W(german)
        opts['length'] = '30'
        opts['groups'] = [Group.all.to_a[1].id.to_s, Group.all.to_a[2].id.to_s]

        result = SearchServiceOffers.with_options opts
        possible_offers = result.fetch :offers
        expect(possible_offers.length).to eql(2)
      end

    end

    def options
      {
        'groups' => [Group.first.id.to_s],
        'length' => '30',
        'times' => [{
          'ends' => Time.now.to_s,
          'starts' => (Time.now + 1.hour).to_s
        }],
        'languages' => ['german']
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

    def create_availability(opts = {})
      opts = {
        user: User.first,
        starts: Time.now,
        ends: Time.now + 1.hour
      }.merge opts
      Availability.create! opts
    end

    def create_offer(opts = {})
      opts = {
        user: User.first,
        description: 'Foo',
        experience: 3,
        rate: 45,
        lengths: %W(30 90 120),
        enabled: true,
        group: Group.first
      }.merge opts
      Offer.create opts
    end
  end
end
