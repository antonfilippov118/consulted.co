class Availability::TimeBlock
  include Mongoid::Document
  embedded_in :availability

  LENGTH = 5.minutes

  field :start, type: Integer
  field :end, type: Integer
  field :status, type: Integer, default: -> { Availability::TimeBlock::Status::FREE }

  attr_readonly :start, :end
  validates_presence_of :start, :end

  delegate :user, to: :availability

  def starting=(time)
    self.start = Time.at(time.to_i - (time.to_i % LENGTH)).to_i
    self.end   = start + LENGTH
  end

  def block!
    self.status = Availability::TimeBlock::Status::BLOCKED
    self
  end

  def book!
    self.status = Availability::TimeBlock::Status::BOOKED
    self
  end

  def free!
    self.status = Availability::TimeBlock::Status::FREE
    self
  end

  class Status
    FREE    = 0
    BLOCKED = 1
    BOOKED  = 2
  end

  scope :free, -> { where status: Availability::TimeBlock::Status::FREE }
  scope :blocked, -> { where status: Availability::TimeBlock::Status::BLOCKED }
  scope :booked, -> { where status: Availability::TimeBlock::Status::BOOKED }
  scope :with_start, -> start { where start: start }
  scope :with_starts, -> starts { where start: { :$in => starts } }

end
