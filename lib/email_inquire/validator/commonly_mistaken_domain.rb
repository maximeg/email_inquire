# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class CommonlyMistakenDomain < Base

      MISTAKES = {
        /google(?!mail)/ => "gmail.com",
        /windows.*\.com/ => "live.com",
      }.freeze

      def validate
        return response.valid! if MISTAKES.value?(domain)

        _mistake, reference =
          MISTAKES.find do |mistake, _reference|
            mistake =~ domain
          end

        response.hint!(domain: reference) if reference
      end

    end
  end
end
