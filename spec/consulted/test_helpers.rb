module Consulted
  module TestHelpers

    def valid_params
      {
        email: 'florian@consulted.co',
        name: 'Florian',
        password: 'tester',
        password_confirmation: 'tester',
        confirmation_sent_at: Time.now
      }
    end

    class EmailTemplates

      def self.create!
        templates.each do |template|
          EmailTemplate.create! template
        end
      end

      private

      def self.templates
        %w(signup_confirmation signup_confirmation_reminder account_deletion forgotten_password funds_paid_out payment_received call_requested_by_seeker call_requested_to_expert call_final_confirmation_to_seeker call_final_confirmation_to_expert call_declined_by_expert_to_seeker call_declined_by_expert_manually call_declined_by_expert_auto call_reminder_to_seeker call_reminder_to_expert call_followup_to_seeker call_cancelled_by_seeker_to_seeker call_cancelled_by_seeker_to_expert call_cancelled_by_expert_to_seeker call_cancelled_by_expert_to_expert call_abandoned_by_seeker_to_expert call_abandoned_by_seeker_to_seeker).map do |name|
          {
            name: name,
            html_version: 'foo',
            text_version: 'bar',
            subject: name
          }
        end
      end
    end
  end

end
