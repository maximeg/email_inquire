# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class UniqueDomainProvider < Base

      DOMAINS = load_data("unique_domain_providers").freeze

      def validate
        return response.valid! if DOMAINS.include?(domain)

        base, _tld = domain.split(".", 2)

        replacement_domain =
          DOMAINS.find do |reference|
            reference_base, _reference_tld = reference.split(".")

            reference_base.eql?(base)
          end

        response.hint!(domain: replacement_domain) if replacement_domain
      end

    end
  end
end
