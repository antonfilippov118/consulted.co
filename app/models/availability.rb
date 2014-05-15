class Availability
  include Mongoid::Document
  include Scopable::Availability

  BLOCK = 5.minutes

  belongs_to :user
  has_many :time_blocks
  alias_method :blocks, :time_blocks

  field :starting, type: DateTime
  field :ending, type: DateTime
  field :date

  validates_presence_of :user, :starting, :ending

  def start=(time)
    self.starting = Time.at(time.to_i - (time.to_i % BLOCK))
  end

  def end=(time)
    self.ending = Time.at(time.to_i - (time.to_i % BLOCK))
  end

  def call_possible?(offer = nil)
    return false unless blocks.free.exists?
    intervals = blocks_available offer
    intervals.include? true
  end

  def next_possible_time(offer = nil)
    return false unless call_possible?
    timestamps = candidates(offer).reject { |a| a[0] == false }.map { |a| a[1].map { |b| b[1] } }
    timestamps.reject! { |_timestamps| !enough_blocks?(_timestamps, offer) }
    ts = timestamps.reduce(:+).uniq.reject { |timestamp| timestamp < (Time.now.to_i + user.start_delay.minutes) }

    return false unless enough_blocks? ts, offer
    Time.at ts.min
  end

  def maximum_call_length(offer)
    lengths = candidates(offer).map { |b, c| { viable: b, times: c.map { |a| a[1] } } }
    lengths = lengths.reject { |l| l[:viable] == false }
    maximum = lengths.map { |l| l[:times].count }.max * 5
    last    = 0
    offer.lengths.each do |length|
      break if length > maximum
      last = length
    end
    last
  end

  def book!(start, length)
    set_status! start, length, :book
  end

  def block!(start, length)
    set_status! start, length, :block
  end

  private

  def viable_params?(b, c, offer = nil)
    {
      viable: b && c.length > minimum_blocks_for(offer),
      time: c.map(&:last).reject { |time| time < Time.now.to_i }.sort.min,
      blocks: enough_blocks?(c, offer)
    }
  end

  def blocks_available(offer)
    blocks.map(&:status).chunk { |c| c == TimeBlock::Status::FREE }.map { |c, d| c == true && enough_blocks?(d, offer) }
  end

  def candidates(offer = nil)
    intervals  = blocks.map { |b| [b.status == TimeBlock::Status::FREE, b.start] }
    intervals.chunk { |b| b[0] == true }
  end

  def viables(offer = nil)
    candidates.map { |b, c| viable_params?(b, c, offer) }.reject { |c| c[:viable] == false || c[:blocks] == false }
  end

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
    offer.lengths.min / 5 - 1
  end

  def enough_blocks?(times, offer = nil)
    times.length >= minimum_blocks_for(offer)
  end

  def set_status!(start, length, state)
    interval = length / (BLOCK / 60)
    fail 'cannot use length!' unless interval.is_a? Integer
    starts = interval.times.map { |n| start + (n * 5).minutes }.map(&:to_i)
    blocks.with_starts(starts).to_a.each do |block|
      case state
      when :book then block.book!
      when :block then block.block!
      end
    end
  end

  before_save do
    self.date = starting.strftime '%Y-%m-%d'
  end

  after_save do
    update_blocks!
  end

  index date: 1

end
