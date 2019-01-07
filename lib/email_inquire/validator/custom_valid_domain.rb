# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class CustomValidDomain < Base

      def validate
        response.valid! if EmailInquire.custom_valid_domains.include?(domain)
      end

    end
  end
end
