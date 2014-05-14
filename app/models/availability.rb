class Availability
  include Mongoid::Document

  BLOCK = 5.minutes

  belongs_to :user
  has_many :time_blocks
  alias_method :blocks, :time_blocks

  field :starting, type: DateTime
  field :ending, type: DateTime
  field :date

  validates_presence_of :user, :starting, :ending
  scope :with_date, -> dates { where date: { :$in => dates } }
  scope :next_days, -> days { where ending: { :$lte => days.days.from_now } }

  def start=(time)
    self.starting = Time.at(time.to_i - (time.to_i % BLOCK))
  end

  def end=(time)
    self.ending = Time.at(time.to_i - (time.to_i % BLOCK))
  end

  def range
    starting..ending
  end

  def call_possible?
    return false unless blocks.free.exists?
    intervals = blocks.map(&:status).chunk { |c| c == TimeBlock::Status::FREE }.map { |c, d| c == true && d.length > 5 }
    intervals.include? true
  end

  def next_possible_time
    return false unless call_possible?
    intervals = blocks.map { |b| [b.status == TimeBlock::Status::FREE, b.start] }
    candidates = intervals.chunk { |b| b[0] == true }.map { |b, c| { viable: b && c.length > 5, time: c.map(&:last).sort.min } }
    viable = candidates.reject { |c| c[:viable] == false }.map { |c| c[:time] }.min
    Time.at viable
  end

  private

  def update_blocks!
    start = starting
    while start < ending
      block = blocks.with_start(start.to_i).exists?
      unless block
        blocks.create starting: start
      end
      start += TimeBlock::LENGTH
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
