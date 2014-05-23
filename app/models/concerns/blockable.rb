module Blockable
  extend ActiveSupport::Concern

  def update_blocks!
    start = starting
    while start < ending
      block = blocks.with_start(start.to_i).exists?
      unless block
        blocks.new(starting: start)
      end
      start += Availability::TimeBlock::LENGTH
    end
    blocks.where(end: { :$gt => ending }).delete_all
    blocks.where(start: { :$lt => starting }).delete_all
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
    blocks.with_starts(starts).to_a.each { |block| block.send "#{state}!" }
    save
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

    before_save do
      update_blocks!
    end
  end
end
