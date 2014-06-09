collection :@calls
attributes :name, :message, :status, :payment, :length, :active, :payment, :pin, :language

node :active_from do |call|
  call.active_from.to_i * 1000
end
node :cost do |call|
  (call.fee + call.rate).to_f / 100
end
node :seeker do |call|
  seeker?(call)
end
node :expert do |call|
  expert? call
end
node :active do |call|
  call.active?
end
node :partner_name do |call|
  partner_for(call).name
end
node :timestamp do |call|
  call.active_from.to_i
end
node :id do |call|
  call.id.to_s
end
node :controllable do |call|
  [Call::Status::REQUESTED, Call::Status::ACTIVE].include? call.status
end
node :partner do |call|
  {
    profile_image_url: partner_for(call).profile_image.url,
    linkedin: partner_for(call).linkedin_url,
    twitter: partner_for(call).twitter_url,
    page: expert_page(call.expert)
  }
end
child :review do
  attributes :awesome, :understood_problem, :helped_solve_problem, :knowledgeable, :value_for_money, :would_recommend,
             :feedback, :would_recommend_consulted
end
child :group do
  attributes :slug
end
node :invoice_pdf_url do |call|
  call.invoice.blank? ? nil : call.invoice.pdf.url
end
