class Invoice::PDF

  def initialize(invoice)
    @invoice = invoice
  end

  def html
    # Use ApplicationController instead of ActionController::Base to use view helpers in render
    @html ||= ApplicationController.new.render_to_string(template: 'pdfs/invoice', layout: false, locals: { invoice: @invoice })
  end

  def generate
    WickedPdf.new.pdf_from_string(html)
  end
end
