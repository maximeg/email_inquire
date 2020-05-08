# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class CustomInvalidDomain < Base

      def validate
        response.invalid! if EmailInquire.custom_invalid_domains.include?(domain)
      end

    end
  end
end
