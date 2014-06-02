# encoding: utf-8
require 'spec_helper'

describe Invoice do
  let(:invoice) { Invoice.create! }

  context 'id for invoice' do
    it 'should present' do
      expect(invoice.id_for_invoice).not_to be_blank
    end

    it 'should be larger than initial seed' do
      expect(invoice.read_attribute(:id_for_invoice)).to be > 30_565_432
    end

    it 'invoice tokens should increment' do
      expect(Invoice.create.read_attribute(:id_for_invoice)).to be < Invoice.create.read_attribute(:id_for_invoice)
    end

    it 'should be numerical token with prefix' do
      expect(invoice.id_for_invoice).to eq "D#{invoice.read_attribute(:id_for_invoice)}"
    end
  end

  context 'create pdf' do
    PDF = "%PDF-1.4\n1 0 obj\n<<\n/Title (\xFE\xFF)\n/Producer (wkhtmltopdf)\n/Crea".force_encoding('ASCII-8BIT')

    before(:each) do
      Invoice::PDF.any_instance.stub(:generate) { PDF }
    end

    it 'should assign pdf field' do
      expect do
        invoice.create_pdf
      end.to change(invoice, :pdf)
    end

    it 'should set pdf field to pdf contents' do
      invoice.create_pdf
      expect(invoice.pdf.data).to eq PDF
    end

    it 'should set name for pdf' do
      invoice.create_pdf
      expect(invoice.pdf.name).to eq "Consulted_Invoice_#{invoice.id_for_invoice}.pdf"
    end

  end

end
