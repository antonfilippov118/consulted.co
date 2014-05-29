require 'mongoid_token'
require 'mongoid_auto_increment'

module Tokenable
  module User
    extend ActiveSupport::Concern
    include Mongoid::Token

    included do
      token :pattern => '%C%C%d7', :field_name => :id_for_invoice, :skip_finders => true, :override_to_param => false
    end
  end

  module Invoice
    extend ActiveSupport::Concern

    def id_for_invoice
      self.read_attribute(:id_for_invoice).nil? ? nil : "D#{self.read_attribute(:id_for_invoice)}"
    end

    included do
      auto_increment :id_for_invoice, :seed => 30565432
    end
  end

  module Call
    extend ActiveSupport::Concern

    included do
      auto_increment :id_for_invoice, :seed => 1321864367
    end
  end
end

