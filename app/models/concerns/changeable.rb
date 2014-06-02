module Changeable
  module Call
    extend ActiveSupport::Concern

    included do
      def confirm!
        self.status = ::Call::Status::ACTIVE
        save!
      end

      def decline!
        self.status = ::Call::Status::DECLINED
        save!
      end

      def cancel!
        self.cancelled_at = Time.now
        self.status = ::Call::Status::CANCELLED
        save!
      end

      def complete!
        self.status = ::Call::Status::COMPLETED
        save
      end

      def active?
        status == ::Call::Status::ACTIVE
      end

      def cancelled?
        status == ::Call::Status::CANCELLED
      end

      def declined?
        status == ::Call::Status::DECLINED
      end

      def complete?
        status == ::Call::Status::COMPLETED
      end
    end
  end
end
