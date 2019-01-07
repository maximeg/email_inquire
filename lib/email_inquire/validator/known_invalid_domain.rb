# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class KnownInvalidDomain < Base

      DOMAINS = load_data("known_invalid_domains").freeze

      def validate
        response.invalid! if DOMAINS.include?(domain)
      end

    end
  end
end
