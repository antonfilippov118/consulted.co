namespace :invoices do
  desc 'creates invoices for completed calls after dispute period ends'
  task create: :environment do
    CreatesInvoices.do
  end
end
