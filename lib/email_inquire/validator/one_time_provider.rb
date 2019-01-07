# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class OneTimeProvider < Base

      DOMAINS = load_data("one_time_providers").freeze

      def validate
        response.invalid! if DOMAINS.include?(domain)
      end

    end
  end
end
