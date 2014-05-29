
class Invoice
  require 'invoice/pdf'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Tokenable::Invoice

  extend Dragonfly::Model

  field :pdf_uid
  dragonfly_accessor :pdf

  has_one :call
  delegate :expert, :seeker, :offer, to: :call
  delegate :id_for_invoice, :length, :active_from, to: :call, prefix: true
  delegate :id_for_invoice, :name, to: :expert, prefix: true
  delegate :id_for_invoice, :name, :timezone, to: :seeker, prefix: true

  def create_pdf
    pdf_gen = Invoice::PDF.new(self)
    self.pdf = pdf_gen.generate
    self.pdf.name = "Consulted_Invoice_#{self.id_for_invoice}.pdf"
    self.save!
  end

  def amount
    self.call.cost
  end

  def date
    self.created_at.to_time.getlocal(Time.find_zone(seeker_timezone).formatted_offset)
  end
  alias_method :due_date, :date

  def call_date
    call_active_from.to_time.getlocal(Time.find_zone(seeker_timezone).formatted_offset)
  end

end
