# frozen_string_literal: true

require "damerau-levenshtein"
require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class CommonProvider < Base

      DOMAINS = load_data("common_providers").freeze

      def validate
        response.valid! if DOMAINS.include?(domain)
      end

    end
  end
end
