class TimeBlock
  include Mongoid::Document
  belongs_to :availability
  LENGTH = 5.minutes
  field :start, type: DateTime
  field :end, type: DateTime
  field :status, type: Integer, default: -> { TimeBlock::Status::FREE }

  attr_readonly :start, :end
  validates_presence_of :start, :end

  delegate :user, to: :availability

  def starting=(time)
    self.start = Time.at(time.to_i - (time.to_i % LENGTH))
    self.end   = start + LENGTH
  end

  class Status
    FREE    = 0
    BLOCKED = 1
    BOOKED  = 2
  end

  scope :free, -> { where status: TimeBlock::Status::FREE }
  scope :blocked, -> { where status: TimeBlock::Status::BLOCKED }
  scope :booked, -> { where status: TimeBlock::Status::BOOKED }
end
