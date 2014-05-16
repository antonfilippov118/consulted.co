module Blockable
  extend ActiveSupport::Concern

  def update_blocks!
    start = starting
    while start < ending
      block = blocks.with_start(start.to_i).exists?
      unless block
        blocks.create(starting: start)
      end
      start += TimeBlock::LENGTH
    end
  end

  def minimum_blocks_for(offer = nil)
    return 5 if offer.nil?
    offer.lengths.min.to_i / 5 - 1
  end

  def enough_blocks?(times, offer = nil)
    times.length >= minimum_blocks_for(offer)
  end

  def set_status!(start, length, state)
    interval = length / 5
    fail 'cannot use length!' unless interval.is_a? Integer
    starts = interval.times.map { |n| start + (n * 5).minutes }.map(&:to_i)
    blocks.with_starts(starts).to_a.each do |block|
      case state
      when :book then block.book!
      when :block then block.block!
      when :free then block.free!
      end
    end
  end

  included do
    def book!(start, length)
      set_status! start, length, :book
    end

    def free!(start, length)
      set_status! start, length, :free
    end

    def block!(start, length)
      set_status! start, length, :block
    end

    after_save do
      update_blocks!
    end
  end
end
