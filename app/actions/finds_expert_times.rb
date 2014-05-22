class FindsExpertTimes
  include LightService::Organizer

  def self.for(user, length)
    with(user: user, length: length).reduce [
      MapAvailabilities,
      FindPossibleBlockIntervals
    ]
  end

  class MapAvailabilities
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      blocks = user.availabilities.future.map do |availability|
        availability.blocks.where(start: { :$gte => Time.now + user.start_delay.minutes }).to_a
      end
      context[:blocks] = blocks
    end
  end

  class FilterBlocks
    include LightService::Action

    executed do |context|
      blocks = context.fetch :blocks
      length = context.fetch :length
      required_blocks = length / 300
      context[:blocks] = blocks.reject do |block|
        block.length < required_blocks
      end
    end
  end

  class FindPossibleBlockIntervals
    include LightService::Action
    executed do |context|
      blocks = context.fetch :blocks
      required_blocks =  context.fetch(:length) / 300

      intervals = blocks.map do |block|
        block.chunk { |b| b.status == 0 }.map { |b, c| { usable: b && c.length >= required_blocks, blocks: c } }
      end
      times = intervals.map { |i| i.reject { |obj| obj[:usable] == false } }
      times = times.map { |t| t.map { |obj| { start: obj[:blocks].first, end: obj[:blocks].last } } }
      context[:times] = times.flatten
    end
  end
end
