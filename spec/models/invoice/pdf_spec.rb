# encoding: utf-8
require 'spec_helper'

describe Invoice::PDF do
  let(:pdf) { Invoice::PDF.new(Invoice.new) }

  before(:each) do
    Invoice.any_instance.stub(:id_for_invoice).and_return('D45213214')
    Invoice.any_instance.stub(:amount).and_return(34.1)
    Invoice.any_instance.stub(:seeker_id_for_invoice).and_return('AD4628261')
    Invoice.any_instance.stub(:call_id_for_invoice).and_return(1321864367)
    Invoice.any_instance.stub(:expert_id_for_invoice).and_return('ZM4018321')
    Invoice.any_instance.stub(:seeker_name).and_return('Matthew Robins')
    Invoice.any_instance.stub(:expert_name).and_return('Anthony Hopkins')
    Invoice.any_instance.stub(:call_length).and_return(90)
    Invoice.any_instance.stub(:created_at).and_return(Time.now)
    Invoice.any_instance.stub(:call_active_from).and_return(Time.now)
    Invoice.any_instance.stub(:seeker_timezone).and_return('Europe/Berlin')
  end

  context 'pdf' do
    it 'should generate pdf' do
      result = pdf.generate
      expect(result).not_to be_blank
      expect(result.encoding.to_s).to eq 'ASCII-8BIT'
    end
  end

  context 'html' do
    let(:html) { pdf.html }
    let(:page) { Capybara::Node::Simple.new(html) }

    it 'should contain amount due' do
      expect(page).to have_text '$34.10'
    end

    it 'should contain invoice id' do
      expect(page).to have_text 'D45213214'
    end

    it 'should have invoice list with amount and text' do
      page.within '.invoice-list' do |inv|
        expect(inv).to have_text '$34.10'
        expect(inv).to have_text 'Anthony Hopkins'
        expect(inv).to have_text '1321864367'
      end
    end
  end
end