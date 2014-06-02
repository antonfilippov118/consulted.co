require 'spec_helper'

describe CreatesInvoices do
  let(:action) { CreatesInvoices }
  let(:expert) { User.create! valid_params.merge timezone: 'Europe/Berlin' }
  let(:user) { User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co' }

  let(:call_ready_for_invoice) do
    call = Call.create active_from: Time.now - (Settings.call_dispute_period + 24).hours - 30.minutes, expert: expert, length: 30, seeker: user
    call.complete!
    call
  end

  let(:call_not_ready_for_invoice) do
    call = Call.create active_from: Time.now - 30.minutes - (Settings.call_dispute_period / 2).to_i.hours, expert: expert, length: 30, seeker: user
    call.complete!
    call
  end

  before(:each) { Invoice::PDF.any_instance.stub(:generate).and_return(''.force_encoding('ASCII-8BIT')) }

  it 'should finish successfully' do
    call_ready_for_invoice
    expect(action.do.success?)
  end

  it 'should create invoice for call after dispute period ends' do
    call_ready_for_invoice
    Call.any_instance.should_receive(:create_invoice).once
    action.do
  end

  it 'should decrease calls without invoice' do
    call_ready_for_invoice
    expect do
      action.do
    end.to change(Call.completed.without_invoice, :count).by(-1)
  end

  it 'should only create invoices for calls after dispute ends' do
    call_ready_for_invoice
    call_not_ready_for_invoice
    action.do
    expect(call_ready_for_invoice.reload.invoice).not_to be_blank
    expect(call_not_ready_for_invoice.reload.invoice).to be_blank
  end
end
