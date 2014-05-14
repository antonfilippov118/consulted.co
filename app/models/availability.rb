class Availability
  include Mongoid::Document

  belongs_to :user
  has_many :time_blocks

  field :starting, type: DateTime
  field :ending, type: DateTime

  validates_presence_of :user

  before_save do
    purge_blocks!
  end

  after_save do
    create_blocks!
  end

  alias_method :blocks, :time_blocks

  private

  def purge_blocks!
    time_blocks.delete_all
  end

  def create_blocks!
    start = starting
    while start < ending
      blocks.create starting: start
      start += TimeBlock::LENGTH
    end
  end

  def start
    blocks.first.start
  end

  def end
    blocks.last.end
  end
end
