class TimeBlock
  include Mongoid::Document
  belongs_to :availability

  LENGTH = 5.minutes

  field :start, type: Integer
  field :end, type: Integer
  field :status, type: Integer, default: -> { TimeBlock::Status::FREE }

  attr_readonly :start, :end
  before_validation :ensure_has_only_one_record, on: :create
  validates_presence_of :start, :end, :availability

  delegate :user, to: :availability

  def starting=(time)
    self.start = Time.at(time.to_i - (time.to_i % LENGTH)).to_i
    self.end   = start + LENGTH
  end

  def block!
    update_attribute :status, TimeBlock::Status::BLOCKED
  end

  def book!
    update_attribute :status, TimeBlock::Status::BOOKED
  end

  class Status
    FREE    = 0
    BLOCKED = 1
    BOOKED  = 2
  end

  scope :free, -> { where status: TimeBlock::Status::FREE }
  scope :blocked, -> { where status: TimeBlock::Status::BLOCKED }
  scope :booked, -> { where status: TimeBlock::Status::BOOKED }
  scope :with_start, -> start { where start: start }

  private

  def ensure_has_only_one_record
    if availability.blocks.with_start(start).exists?
      errors.add :base, 'timeblock already exists!'
    end
  end
end
