class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  SPLITTER = ','

  field :name, type: String
  slug :name
  field :description, type: String
  field :seeker_gain, type: String
  field :seeker_expectation, type: String
  field :expert_background, type: String
  field :length_gain, type: String
  field :tag_array, type: Array

  validates_associated :parent, :children

  before_destroy :destroy_children

  has_many :calls
  has_many :offers

  def self.with_tag(tag)
    if tag.is_a? String
      tag = tag.split ' '
    end
    any_in :tag_array.in => tag.map(&:downcase)
  end

  def tags
    (tag_array || []).join SPLITTER
  end

  def tags=(items)
    if items.present?
      self.tag_array = items.split(SPLITTER).map(&:strip).reject(&:blank?).map(&:downcase)
    else
      self.tag_array = []
    end
  end
end
