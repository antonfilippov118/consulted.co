class Call
  include Mongoid::Document
  include Mongoid::Timestamp

  belongs_to :expert, class_name: 'User'
  belongs_to :seeker, class_name: 'User'
end
