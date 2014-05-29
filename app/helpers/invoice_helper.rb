module InvoiceHelper
  def invoice_amount(invoice)
    number_to_currency invoice.amount
  end

  def invoice_date(invoice)
    invoice.date.strftime('%D')
  end

  def invoice_due_date(invoice)
    invoice.due_date.strftime('%D')
  end

  def invoice_call_date(invoice)
    invoice.call_date.strftime('%D')
  end
end
