step 'Platform settings exist' do
  @platform_settings = create :platform_settings
end

step 'I go to platform settings page' do
  visit rails_admin.index_path(model_name: 'PlatformSettings')
end

step 'I go to edit platform settings page' do
  visit rails_admin.edit_path(model_name: 'PlatformSettings', id: @platform_settings.id)
end

step 'I should see platform settings' do
  @platform_settings.attributes.except('_id').each do |attribute, value|
    if attribute == 'required_network'
      within 'table tbody tr.platform_settings_row' do
        click_link '...'
      end
    end

    page.should have_content(attribute.humanize)

    within 'table tbody tr.platform_settings_row' do
      page.should have_css("td.#{attribute}_field", text: value)
    end
  end
end

step 'I change platform settings' do
  fill_in :platform_settings_platform_fee, with: 5
  fill_in :platform_settings_cancellation_fee, with: 10
  fill_in :platform_settings_call_dispute_period, with: 15
  fill_in :platform_settings_block_time, with: 20
  fill_in :platform_settings_session_timeout, with: 25

  page.find('button[name="_save"]').trigger(:click)
end

step 'I should see platform settings changed' do
  within 'table tbody tr.platform_settings_row' do
    page.should have_css('td.platform_fee_field', text: 5)
    page.should have_css('td.cancellation_fee_field', text: 10)
    page.should have_css('td.call_dispute_period_field', text: 15)
    page.should have_css('td.block_time_field', text: 20)
    page.should have_css('td.session_timeout_field', text: 25)
  end
end
