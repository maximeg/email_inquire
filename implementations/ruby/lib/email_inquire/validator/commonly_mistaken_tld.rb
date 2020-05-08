# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class CommonlyMistakenTld < Base

      MISTAKES = {
        ".combr" => ".com.br",
        ".cojp" => ".co.jp",
        ".couk" => ".co.uk",
        ".com.com" => ".com",
      }.freeze

      def validate
        mistake, reference =
          MISTAKES.find do |mistake, reference|
            next if !mistake.end_with?(reference) && domain.end_with?(reference)

            domain.end_with?(mistake)
          end

        response.hint!(domain: domain.sub(/#{mistake}\z/, reference)) if reference
      end

    end
  end
end
